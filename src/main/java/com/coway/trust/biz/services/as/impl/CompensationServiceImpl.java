package com.coway.trust.biz.services.as.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.services.as.CompensationService;
import com.coway.trust.biz.services.servicePlanning.impl.HolidayMapper;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("CompensationService")
public class  CompensationServiceImpl  extends EgovAbstractServiceImpl implements CompensationService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CompensationServiceImpl.class);
	
	@Resource(name = "CompensationMapper")
	private CompensationMapper compensationMapper;

	@Resource(name = "holidayMapper")
	private HolidayMapper holidayMapper;	
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	@Override
	public List<EgovMap> selCompensationList(Map<String, Object> params) {
		return compensationMapper.selCompensationList(params);
	}
	

	@Override
	public EgovMap selectCompenSationView(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return compensationMapper.selectCompenSationView(params);
	}
	
	@Override
	public EgovMap  insertCompensation(Map<String, Object> params) {
		
		EgovMap saveView = new EgovMap();	
		
		compensationMapper.insertCompensation(params);
		
		saveView.put("success", true); 
		saveView.put("massage", messageSourceAccessor.getMessage(SalesConstants.MSG_DCF_SUCC)); 
		
		return saveView;
	} 	
	
	
	@Override
	public List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params) {
		return compensationMapper.selectSalesOrdNoInfo(params);
	}
	
	
	@Override
	public EgovMap  updateCompensation(Map<String, Object> params) {

		EgovMap saveView = new EgovMap();	
		
		System.out.println("======================================================================================");
		System.out.println("===============================compensationPop updateCompensation params "+ params);
		System.out.println("======================================================================================");
		
		
		compensationMapper.updateCompensation(params);
		
		saveView.put("success", true); 
		saveView.put("massage", messageSourceAccessor.getMessage(SalesConstants.MSG_DCF_SUCC)); 
		
		return saveView;
	}
	
	@Override
	public List<EgovMap> selectBranchWithNM() {
		
		return holidayMapper.selectBranchWithNM();
	}
} 
