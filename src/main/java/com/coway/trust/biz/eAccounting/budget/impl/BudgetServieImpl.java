package com.coway.trust.biz.eAccounting.budget.impl;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.eAccounting.budget.BudgetService;
import com.coway.trust.biz.sales.ccp.impl.CcpAgreementServieImpl;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("budgetService")
public class BudgetServieImpl extends EgovAbstractServiceImpl implements BudgetService {

	private static final Logger Logger = LoggerFactory.getLogger(CcpAgreementServieImpl.class);
	
	@Resource(name = "budgetMapper")
	private BudgetMapper budgetMapper;

	@Override
	public List<EgovMap> selectMonthlyBudgetList( Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return budgetMapper.selectMonthlyBudgetList(params);
	}

	@Override
	public EgovMap selectAvailableBudgetAmt(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return budgetMapper.selectAvailableBudgetAmt(params);
	}

	@Override
	public List<EgovMap> selectAdjustmentAmount( Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return budgetMapper.selectAdjustmentAmount(params);
	}
	
	@Override
	public List<EgovMap> selectPenConAmount( Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return budgetMapper.selectPenConAmount(params);
	}
	
	@Override
	public List<EgovMap> selectAdjustmentList( Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return budgetMapper.selectAdjustmentList(params);
	}

	@Override
	public int saveAdjustmentInfo(Map<String, Object> params) throws Exception {
		
		List<Object> addList = (List<Object>) params.get("addList");
		List<Object> updList = (List<Object>) params.get("updList");
		List<Object> delList = (List<Object>) params.get("delList");
		
		int addCnt=0;
		int updCnt=0;
		int delCnt=0;
		
		if(addList.size() > 0){
			
			int i = 0;
			for (Object obj : addList) 
			{
				
				((Map<String, Object>) obj).put("userId", params.get("userId"));
				
				Logger.debug(" >>>>> insertAdjustmentInfo ");
				Logger.debug(" userId : {}", ((Map<String, Object>) obj).get("userId"));
							
				addCnt++;

				if(addCnt == 1){
					
					((Map<String, Object>) obj).put("atchFileGrpId", params.get("atchFileGrpId"));
					budgetMapper.insertAdjustmentM((Map<String, Object>) obj);
				}
				String  budgetDocNo = (String) ((Map<String, Object>) obj).get("id");
				Logger.debug("id ===============>>> " +budgetDocNo) ;
				((Map<String, Object>) obj).put("budgetDocNo",  budgetDocNo);
				budgetMapper.insertAdjustmentD((Map<String, Object>) obj);
			}
		}
		
		if(updList.size() > 0){
			for (Object obj : addList) 
			{
				((Map<String, Object>) obj).put("userId", params.get("userId"));
				
				Logger.debug(" >>>>> updateAdjustmentInfo ");
				Logger.debug(" userId : {}", ((Map<String, Object>) obj).get("userId"));
							
				updCnt++;

				budgetMapper.updateAdjustmentInfo((Map<String, Object>) obj);
			}
		}
		
		if(delList.size() > 0){
			for (Object obj : addList) 
			{
				((Map<String, Object>) obj).put("userId", params.get("userId"));
				
				Logger.debug(" >>>>> deleteAdjustmentInfo ");
				Logger.debug(" userId : {}", ((Map<String, Object>) obj).get("userId"));
							
				delCnt++;

				budgetMapper.deleteAdjustmentInfo((Map<String, Object>) obj);
			}
		}
		
		
		return addCnt+updCnt+delCnt;
	}
	
	
	/*
	
	@Override
	public int insertAdjustmentInfo(List<Object> addList, Integer crtUserId) throws Exception 
	{
		int saveCnt = 0;
		
		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			Logger.debug(" >>>>> insertAdjustmentInfo ");
			Logger.debug(" userId : {}", ((Map<String, Object>) obj).get("userId"));
						
			saveCnt++;

			budgetMapper.insertAdjustmentInfo((Map<String, Object>) obj);
		}

		return saveCnt;
	}
	
	@Override
	public int updateAdjustmentInfo(List<Object> updList, Integer crtUserId) throws Exception 
	{
		int saveCnt = 0;
		
		for (Object obj : updList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			Logger.debug(" >>>>> updateAdjustmentInfo ");
			
			Logger.debug("UserId : {}", ((Map<String, Object>) obj).get("userId"));
			
			saveCnt++;
			
			budgetMapper.updateAdjustmentInfo((Map<String, Object>) obj);
			
		}
		
		return saveCnt;
	}	
	
	@Override
	public int deleteAdjustmentInfo(List<Object> delList, Integer crtUserId) throws Exception 
	{
		int delCnt = 0;
		
		for (Object obj : delList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			Logger.debug(" >>>>> deleteAdjustmentInfo ");
			Logger.debug("UserId : {}", ((Map<String, Object>) obj).get("userId"));
			
			delCnt++;
			
			budgetMapper.deleteAdjustmentInfo((Map<String, Object>) obj);

		}
		
		return delCnt;
	}		
	*/
}
