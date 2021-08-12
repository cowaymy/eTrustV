package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.common.CommonMyPopService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("commonMyPopService")
public class CommonMyPopServiceImpl implements CommonMyPopService {
	
	@Autowired
	private CommonMyPopMapper commonMyPopMapper;
	
	@Override
	public List<EgovMap> selectCommonMyPopList(Map<String, Object> params) {		
		return commonMyPopMapper.selectDefaultList(params);				
	}
}
