package com.coway.trust.biz.logistics.memorandum.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.memorandum.MemorandumService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("memosvc")
public class MemorandumServiceImpl extends EgovAbstractServiceImpl implements MemorandumService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "memoMapper")
	private MemorandumMapper memo;

	@Override
	public List<EgovMap> selectMemoRandumList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memo.selectMemoRandumList(params);
	}

	@Override
	public Map<String, Object> memoSave(Map<String, Object> params) {
		// TODO Auto-generated method stub
		Map<String, Object> data = new HashMap();
		if ("upd".equals(params.get("vmode"))) {
			memo.memoUpdate(params);
			data = memo.selectMemoRandumData(params);
		} else {
			memo.memoSave(params);
		}
		return data;

	}

	@Override
	public void memoDelete(Map<String, Object> params) {
		memo.memoDelete(params);

	}

}
