package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.sales.ccp.CcpCalculateService;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ccpCalculateService")
public class CcpCalculateServiceImpl implements CcpCalculateService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpCalculateServiceImpl.class);
	
	@Resource(name = "ccpCalculateMapper")
	private CcpCalculateMapper ccpCalculateMapper;

	
	@Override
	public List<EgovMap> selectDscCodeList() throws Exception {
		
		return ccpCalculateMapper.selectDscCodeList();
	}
	

	@Override
	public List<EgovMap> selectReasonCodeFbList() throws Exception {
		
		return ccpCalculateMapper.selectReasonCodeFbList();
	}


	@Override
	public List<EgovMap> selectCalCcpListAjax(Map<String, Object> params) throws Exception {
		
		return ccpCalculateMapper.selectCalCcpListAjax(params);
	}


	@Override
	public EgovMap getLatestOrderLogByOrderID(Map<String, Object> params) throws Exception {
		
		EgovMap prgMap = null;
		prgMap = ccpCalculateMapper.getPrgId(params);
	
	    return prgMap;
			
	}


	@Override
	public List<EgovMap> getOrderUnitList(Map<String, Object> params) throws Exception {
		
		return ccpCalculateMapper.getOrderUnitList(params);
	}


	@Override
	public EgovMap getCalViewEditField(Map<String, Object> params) throws Exception {
		
		//variable
		EgovMap fieldMap = new EgovMap(); //return
		EgovMap unitSelMap =  null;
		List<EgovMap> countList = null;
		
		//Order Unit
		countList = ccpCalculateMapper.countOrderUnit(params);
		params.put("ordUnitCount", countList.size());
		params.put("ctgyTyId", SalesConstants.CATEGORY_TYPE_ID); //212
		params.put("ctgyMstId", SalesConstants.CATEGORY_MASTER_ID); //2
		unitSelMap = ccpCalculateMapper.orderUnitSelectValue(params);
		fieldMap.put("ordUnitCount", countList.size());
		fieldMap.put("unitSelVal", unitSelMap.get("screEventId"));
		
		//
		
		return fieldMap;
	}
	
	
	
	
}
