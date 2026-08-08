# ============================================================
# 升学规划 Agent 后端代理
# 使用 FastAPI + 智谱AI GLM-4.7-Flash（永久免费）
# 内置请求排队：1并发限制下，多用户自动排队，不报错
# ============================================================
# 启动方式：
#   pip install -r requirements.txt --break-system-packages
#   python main.py
# 服务地址：http://localhost:8000
# ============================================================

import os
import asyncio
import time
import httpx
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from system_prompt import SYSTEM_PROMPT

app = FastAPI(title="升学规划 Agent")

# 允许跨域（Flutter 调试时用）
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================================
# 配置
# ============================================================
# 智谱AI：GLM-4.7-Flash 永久免费，1并发，200K上下文
# 注册地址：https://open.bigmodel.cn
# API Key 获取：https://open.bigmodel.cn/usercenter/proj-mgmt/apikeys
ZHIPU_API_KEY = os.getenv("ZHIPU_API_KEY", "your-zhipu-api-key-here")
ZHIPU_BASE_URL = "https://open.bigmodel.cn/api/paas/v4"

# 备用：SiliconFlow（硅基流动），部分模型永久免费
SILICONFLOW_API_KEY = os.getenv("SILICONFLOW_API_KEY", "")
SILICONFLOW_BASE_URL = "https://api.siliconflow.cn/v1"

# ============================================================
# 请求排队锁 —— 解决免费版 1 并发限制
# ============================================================
# 原理：asyncio.Lock 保证同一时间只有一个请求在调用 AI API
# 后来的请求自动排队等待，不会报 429/503
# 每个请求最多排队 60 秒，超时返回友好提示
_request_lock = asyncio.Lock()
_queue_waiting = 0  # 当前排队人数


class ChatRequest(BaseModel):
    messages: list[dict]
    user_context: str = ""
    stream: bool = False


class ChatResponse(BaseModel):
    content: str
    model: str
    queue_time: float = 0.0  # 排队耗时（秒）


@app.get("/")
def root():
    return {"status": "ok", "service": "升学规划 Agent（智谱AI）", "queue_waiting": _queue_waiting}


@app.get("/health")
def health():
    return {"status": "healthy", "queue_waiting": _queue_waiting}


@app.post("/chat", response_model=ChatResponse)
async def chat(req: ChatRequest):
    global _queue_waiting

    # 构建消息
    user_context = req.user_context or "暂无用户背景信息"
    system_prompt = SYSTEM_PROMPT.format(user_context=user_context)
    full_messages = [{"role": "system", "content": system_prompt}] + req.messages

    # 排队等待
    _queue_waiting += 1
    queue_start = time.time()

    try:
        # 最多等 60 秒获取锁
        acquired = await asyncio.wait_for(_request_lock.acquire(), timeout=60.0)
        if not acquired:
            raise HTTPException(status_code=503, detail="服务繁忙，请稍后重试")
    except asyncio.TimeoutError:
        _queue_waiting -= 1
        return JSONResponse(
            status_code=503,
            content={
                "content": "当前咨询人数较多，请稍后再试。\n\n（排队超过 60 秒，建议过几分钟再问）",
                "model": "queue_timeout",
                "queue_time": time.time() - queue_start,
            },
        )

    _queue_waiting -= 1
    queue_time = time.time() - queue_start

    try:
        # 调用智谱AI
        try:
            result = await _call_zhipu(full_messages)
            result.queue_time = queue_time
            return result
        except Exception as e:
            print(f"智谱AI 调用失败: {e}")

        # 备选：SiliconFlow
        if SILICONFLOW_API_KEY:
            try:
                result = await _call_siliconflow(full_messages)
                result.queue_time = queue_time
                return result
            except Exception as e:
                print(f"SiliconFlow 调用失败: {e}")

        raise HTTPException(status_code=500, detail="所有 AI 服务调用失败")

    finally:
        _request_lock.release()


async def _call_zhipu(messages: list[dict]) -> ChatResponse:
    """调用智谱AI GLM-4.7-Flash"""
    async with httpx.AsyncClient(timeout=60.0) as client:
        resp = await client.post(
            f"{ZHIPU_BASE_URL}/chat/completions",
            headers={
                "Authorization": f"Bearer {ZHIPU_API_KEY}",
                "Content-Type": "application/json",
            },
            json={
                "model": "glm-4.7-flash",
                "messages": messages,
                "temperature": 0.7,
                "max_tokens": 2000,
            },
        )
        if resp.status_code != 200:
            raise Exception(f"智谱AI API 错误: {resp.status_code} {resp.text}")

        data = resp.json()
        return ChatResponse(
            content=data["choices"][0]["message"]["content"],
            model=data.get("model", "glm-4.7-flash"),
        )


async def _call_siliconflow(messages: list[dict]) -> ChatResponse:
    """备选：SiliconFlow"""
    async with httpx.AsyncClient(timeout=60.0) as client:
        resp = await client.post(
            f"{SILICONFLOW_BASE_URL}/chat/completions",
            headers={
                "Authorization": f"Bearer {SILICONFLOW_API_KEY}",
                "Content-Type": "application/json",
            },
            json={
                "model": "Qwen/Qwen2.5-7B-Instruct",
                "messages": messages,
                "temperature": 0.7,
                "max_tokens": 2000,
            },
        )
        if resp.status_code != 200:
            raise Exception(f"SiliconFlow API 错误: {resp.status_code} {resp.text}")

        data = resp.json()
        return ChatResponse(
            content=data["choices"][0]["message"]["content"],
            model=data.get("model", "Qwen/Qwen2.5-7B-Instruct"),
        )


if __name__ == "__main__":
    import uvicorn
    print("=" * 50)
    print("  升学规划 Agent 后端启动中...")
    print("  地址: http://localhost:8000")
    print("  API 文档: http://localhost:8000/docs")
    print("=" * 50)
    print()
    print("  当前使用：智谱AI GLM-4.7-Flash（永久免费，1并发）")
    print("  多用户请求自动排队，不报错")
    print()
    if ZHIPU_API_KEY == "your-zhipu-api-key-here":
        print("  ⚠️  请先设置 ZHIPU_API_KEY 环境变量！")
        print("  注册地址: https://open.bigmodel.cn")
        print("  获取 Key: https://open.bigmodel.cn/usercenter/proj-mgmt/apikeys")
        print("  GLM-4.7-Flash 永久免费，不扣 token")
        print()
    else:
        print("  ✅ API Key 已配置")
        print()
    uvicorn.run(app, host="0.0.0.0", port=8000)