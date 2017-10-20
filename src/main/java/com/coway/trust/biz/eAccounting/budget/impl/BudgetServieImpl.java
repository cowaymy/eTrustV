package com.coway.trust.biz.eAccounting.budget.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.eAccounting.budget.BudgetService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sales.ccp.impl.CcpAgreementServieImpl;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("budgetService")
public class BudgetServieImpl extends EgovAbstractServiceImpl implements BudgetService {

	private static final Logger Logger = LoggerFactory.getLogger(CcpAgreementServieImpl.class);
	
	@Resource(name = "budgetMapper")
	private BudgetMapper budgetMapper;
	
	@Resource(name = "webInvoiceMapper")
	private WebInvoiceMapper webInvoiceMapper;

	@Override
	public List<EgovMap> selectMonthlyBudgetList( Map<String, Object> params) throws Exception {
		return budgetMapper.selectMonthlyBudgetList(params);
	}

	@Override
	public EgovMap selectAvailableBudgetAmt(Map<String, Object> params) throws Exception {
		return budgetMapper.selectAvailableBudgetAmt(params);
	}

	@Override
	public List<EgovMap> selectAdjustmentAmount( Map<String, Object> params) throws Exception {
		return budgetMapper.selectAdjustmentAmount(params);
	}
	
	@Override
	public List<EgovMap> selectPenConAmount( Map<String, Object> params) throws Exception {
		return budgetMapper.selectPenConAmount(params);
	}
	
	@Override
	public List<EgovMap> selectAdjustmentList( Map<String, Object> params) throws Exception {
		return budgetMapper.selectAdjustmentList(params);
	}

	@Override
	public EgovMap saveAdjustmentInfo(Map<String, Object> params) throws Exception {
		
		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

		EgovMap result = new EgovMap();
		
		List<Object> addList = (List<Object>) gridData.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) gridData.get(AppConstants.AUIGRID_UPDATE);
		List<Object> delList = (List<Object>) gridData.get(AppConstants.AUIGRID_REMOVE);
		
		//String atchFileGrpId = params.get("atchFileGrpId").toString();
		
		int addCnt=0;
		int updCnt=0;
		int delCnt=0;

		Object  budgetDocNo = params.get("pBudgetDocNo");
		Map approvalMap = new HashMap<String, Object>();
		
		if(addList.size() > 0){
			
			Logger.debug(" >>>>> insertAdjustmentInfo ");
			
			for (Object obj : addList) 
			{				
				((Map<String, Object>) obj).put("userId", params.get("userId"));
				
				addCnt++;

				if(addCnt == 1 && CommonUtils.isEmpty(budgetDocNo)){
					
					((Map<String, Object>) obj).put("atchFileGrpId", params.get("atchFileGrpId"));
					
					//master table insert 
					budgetMapper.insertAdjustmentM((Map<String, Object>) obj);

					budgetDocNo= (String) ((Map<String, Object>) obj).get("budgetDocNo");
					
				}
				
				//detail table insert
				budgetMapper.insertAdjustmentD((Map<String, Object>) obj);
			}
		}
		
		if(updList.size() > 0){
			
			Logger.debug(" >>>>> updateAdjustmentInfo ");
			
			for (Object obj : updList) 
			{
				((Map<String, Object>) obj).put("userId", params.get("userId"));
							
				updCnt++;

				budgetMapper.updateAdjustmentD((Map<String, Object>) obj);
				
				//TODO 파일 수정시 M table 수정 로직 필요
			}
		}
		
		//approval table insert
		if(params.get("type").toString().equals("approval")){
			
			approvalMap.put("budgetDocNo", budgetDocNo);
			approvalMap.put("userId", params.get("userId"));
			
			
			List<EgovMap> amtList = budgetMapper.selectAvailableAmtList(approvalMap);
			
			String overbudget="N"; //예산 사용 가능
			
			for(int i=0; i < amtList.size(); i++){
				EgovMap amtMap = amtList.get(i);
				
				if(  Float.parseFloat(amtMap.get("total").toString()) > Float.parseFloat(amtMap.get("availableAmt").toString())){
					overbudget = "Y";  //예산 초과
					amtMap.put("overbudget", overbudget);
					result.put("amtMap", amtMap);
					break;
				}				
			}
			if(overbudget.equals("N")){
				budgetMapper.insertApprove(approvalMap); 
			}
		}
		
		/*if(delList.size() > 0){
			for (Object obj : delList) 
			{
				((Map<String, Object>) obj).put("userId", params.get("userId"));
				
				Logger.debug(" >>>>> deleteAdjustmentInfo ");
				Logger.debug(" userId : {}", ((Map<String, Object>) obj).get("userId"));
							
				delCnt++;

				budgetMapper.deleteAdjustmentD((Map<String, Object>) obj);
				
				Map param = new HashMap();
				
				param.put("budgetDocNo", ((Map<String, Object>) obj).get("budgetDocNo"));
				
				if(budgetMapper.selectAdjustmentList(param) == null){

					budgetMapper.deleteAdjustmentM((Map<String, Object>) obj);
				}
			}
		}*/
		
		result.put("totCnt", addCnt+updCnt+delCnt);
		result.put("budgetDocNo", budgetDocNo.toString());
		
		return result ;
	}

	@Override
	public List<EgovMap> selectFileList(Map<String, Object> params) throws Exception {
		return budgetMapper.selectFileList(params);
	}

	@Override
	public EgovMap getBudgetAmt(Map<String, Object> params) throws Exception {		
		return budgetMapper.getBudgetAmt(params);
	}
	
}
