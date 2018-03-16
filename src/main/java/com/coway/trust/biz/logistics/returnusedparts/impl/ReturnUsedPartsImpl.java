package com.coway.trust.biz.logistics.returnusedparts.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.returnusedparts.ReturnUsedPartsService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("returnUsedPartsService")
public class ReturnUsedPartsImpl extends EgovAbstractServiceImpl implements ReturnUsedPartsService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "returnUsedPartsMapper")
	private ReturnUsedPartsMapper returnUsedPartsMapper;

	@Override
	public List<EgovMap> returnPartsList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return returnUsedPartsMapper.returnPartsList(params);
	}
	
	@Override
	public void returnPartsUpdate(Map<String, Object> params,int loginId) {

		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		for (int i = 0; i < checkList.size(); i++) {
			logger.debug("checkList    값 : {}", checkList.get(i));
		}

		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) checkList.get(i);
				insMap.put("userId", loginId);

				returnUsedPartsMapper.upReturnParts(insMap);
				logger.debug("insMap :????????????????????    값 : {}", insMap);
			}
		}

	}
	
	@Override
	public void returnPartsCanCle(Map<String, Object> params) {

		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		for (int i = 0; i < checkList.size(); i++) {
			logger.debug("checkList    값 : {}", checkList.get(i));
		}

		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) checkList.get(i);

				returnUsedPartsMapper.returnPartsCanCle(insMap);
			}
		}

	}
	
	
	//테스트 인서트 딜리트
	@Override
	public void returnPartsInsert(String param) {
		// TODO Auto-generated method stub
		returnUsedPartsMapper.returnPartsInsert(param);
		
	}
	
	@Override
	public void returnPartsdelete(String param) {
		// TODO Auto-generated method stub
		returnUsedPartsMapper.returnPartsdelete(param);
		
	}
	
	@Override
	public int validMatCodeSearch(String matcode) {
		// TODO Auto-generated method stub
		return returnUsedPartsMapper.validMatCodeSearch(matcode);
		
	}
	
	
	@Override
	public int returnPartsdupchek(Map<String, Object> insMap) {
		// TODO Auto-generated method stub
		return returnUsedPartsMapper.returnPartsdupchek(insMap);
		
	}
	
}
