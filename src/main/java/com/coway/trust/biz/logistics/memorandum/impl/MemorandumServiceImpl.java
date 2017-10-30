package com.coway.trust.biz.logistics.memorandum.impl;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.AppConstants;
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

	
}