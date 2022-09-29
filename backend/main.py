from fastapi import FastAPI, File, UploadFile, Request
from analysis.main import analysis as func_analysis

from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

limiter = Limiter(key_func=get_remote_address)
app = FastAPI()
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

@app.get("/")
async def root():
	return "Nishi-X"

@app.get("/health")
async def health():
	return "health"


@app.post("/analysis")
@limiter.limit("500/hour")
async def analysis(request: Request, file: UploadFile = File(...)):
	return func_analysis(file)

@limiter.limit("1000/hour")
@app.post("/m/analysis")
async def mock_analysis(request: Request, file: UploadFile = File(...)):
	data = {
		"body": "私の名前は唐木結也です。",
		"detail": [
			{
				"original": "私",
				"read": "わたし",
				"meaning": "その人個人に関すること。",
			},
			{
				"original": "の",
				"read": "の",
				"meaning": "(助詞)",
			},
			{
				"original": "なまえ",
				"read": "なまえ",
				"meaning": "事物を他の事物と区別して指示するとき使われる言葉。"
			},
			{
				"original": "は",
				"read": "は",
				"meaning": "(助詞)"
			},
			{
				"original": "唐木結也",
				"read": "からきゆうや",
				"meaning": "(人名)"
			},
			{
				"original": "です",
				"read": "です",
				"meaning": "(助動詞)"
			},
			{
				"original": "。",
				"read": "。",
				"meaning": "(句点)"
			},
		]
	}
	return data