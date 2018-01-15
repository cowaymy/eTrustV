package com.coway.trust.biz.services.tagMgmt.impl;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.servicePlanning.HolidayService;
import com.coway.trust.biz.services.tagMgmt.TagMgmtService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("tagMgmtService")
public class TagMgmtServiceImpl implements TagMgmtService {

	private static final Logger logger = LoggerFactory.getLogger(HolidayService.class);
	
	@Resource(name = "tagMgmtMapper")
	private TagMgmtMapper tagMgmtMapper;

	@Override
	public List<EgovMap> getTagStatus(Map<String, Object> params) {
		
		return tagMgmtMapper.selectTagStatus(params);
	}

	@Override
	public EgovMap getDetailTagStatus(Map<String, Object> params) {
		
		return tagMgmtMapper.selectDetailTagStatus(params);
	}

	@Override
	public int addRemarkResult(Map<String, Object> params, SessionVO sessionVO)   throws ParseException{
		int cnt =0;
		
		params.put("userId", sessionVO.getUserId());
		
		
		
		EgovMap mapCheckCallEntryId = tagMgmtMapper.selectCallEntryId(params);
		if(mapCheckCallEntryId == null){
		
    		cnt = tagMgmtMapper.insertCcr0006d(params);

		}
		else {
			
			cnt = tagMgmtMapper.updateCcr0006d(params);
			
		}
		
		EgovMap mapCallEntryId= tagMgmtMapper.selectCallEntryId(params);
		params.put("callEntryId", mapCallEntryId.get("callEntryId") );
		
		cnt += tagMgmtMapper.insertCcr0007d(params);
		
		return cnt;
	}

	@Override
	public List<EgovMap> getTagRemark(Map<String, Object> params) {
		
		EgovMap mapCallEntryId= tagMgmtMapper.selectCallEntryId(params);
		if(mapCallEntryId != null){
			params.put("callEntryId", mapCallEntryId.get("callEntryId") );
		}
		return tagMgmtMapper.selectTagRemarks(params);
	}

	@Override
	public List<EgovMap> getMainDeptList() {
		// TODO Auto-generated method stub
		return tagMgmtMapper.selectMainDept();
	}

	@Override
	public List<EgovMap> getSubDeptList(Map<String, Object> params) {
		
		return tagMgmtMapper.selectSubDept(params);
	}

	@Override
	public List<EgovMap> getMainInquiryList() {
		// TODO Auto-generated method stub
		return tagMgmtMapper.selectMainInquiryList();
	}

	@Override
	public List<EgovMap> getSubInquiryList(Map<String, Object> params) {
	
		return tagMgmtMapper.selectSubInquiryList(params);
	}
	
	@Override
	public EgovMap getOrderInfo(Map<String, Object> params) {
		
		return tagMgmtMapper.getOrderInfo(params);
	}
	
	@Override
	public EgovMap getCallerInfo(Map<String, Object> params) {
		
		return tagMgmtMapper.getCallerInfo(params);
	}
	
	@Override
	public EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params) {
		
		return tagMgmtMapper.selectOrderSalesmanViewByOrderID(params);
	}
	
	@Override
	public EgovMap selectOrderServiceMemberViewByOrderID(Map<String, Object> params) {
		
		return tagMgmtMapper.selectOrderServiceMemberViewByOrderID(params);
	}
	
}
