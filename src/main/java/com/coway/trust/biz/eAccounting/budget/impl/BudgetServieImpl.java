package com.coway.trust.biz.eAccounting.budget.impl;

import java.util.ArrayList;
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
import com.coway.trust.cmmn.exception.ApplicationException;
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
	public List<EgovMap> selectBudgetControlList(Map<String, Object> params) throws Exception {
		return budgetMapper.selectBudgetControlList(params);
	}
	
	@Override 
	public List<EgovMap> selectBudgetSysMaintenanceList(Map<String, Object> params) throws Exception {
		return budgetMapper.selectBudgetSysMaintenanceList(params);
	}

	@Override
	public int addBudgetSysMaintGrid(List<Object> addList,String loginId) {	
		
		int cnt=0;
		
		for (Object obj : addList) {

			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);
			
			cnt=cnt+budgetMapper.addBudgetSysMaintGrid((Map<String, Object>) obj);
		}
		return cnt;
	}
	
	@Override
	public int udtBudgetSysMaintGrid(List<Object> udtList,String loginId) {
		
		int cnt=0;
		for (Object obj : udtList) {		
			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);

			cnt=cnt+budgetMapper.udtBudgetSysMaintGrid((Map<String, Object>) obj);
		}
		return cnt;
	}
	
	@Override
	public List<EgovMap> selectMonthlyBudgetList( Map<String, Object> params) throws Exception {
		return budgetMapper.selectMonthlyBudgetList(params);
	}

	@Override
	public List<EgovMap> selectAdjustmentCBG(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return budgetMapper.selectAdjustmentCBG(params);
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
		Object  atchFileGrpId = params.get("atchFileGrpId");
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

				((Map<String, Object>) obj).put("budgetDocNo", budgetDocNo);
				
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
				
				if(Float.parseFloat(((Map<String, Object>) obj).get("adjAmt").toString()) == 0){  //update 금액이 0 일 경우 삭제
					budgetMapper.deleteAdjustmentD((Map<String, Object>) obj);					
				}else{
					budgetMapper.updateAdjustmentD((Map<String, Object>) obj);
				}

				//해당 문서번호에 상세 내역이 없으면 해당 문서번호도 삭제
				Map param = new HashMap();
				
				param.put("budgetDocNo", ((Map<String, Object>) obj).get("budgetDocNo"));
				
				if(budgetMapper.selectAdjustmentList(param) == null){

					budgetMapper.deleteAdjustmentM((Map<String, Object>) obj);
				}
				
			}
		}
		
		if(delList.size() > 0){
    		for (Object obj : delList) {
    			((Map<String, Object>) obj).put("userId", params.get("userId"));
    			
    			Logger.debug(" >>>>> deleteAdjustmentInfo ");
    			Logger.debug(" userId : {}", ((Map<String, Object>) obj).get("userId"));
    						
    			delCnt++;
    
    			budgetMapper.deleteAdjustmentD((Map<String, Object>) obj);
    			
    			Map param = new HashMap();
    			
    			param.put("budgetDocNo", ((Map<String, Object>) obj).get("budgetDocNo"));
				
				if(budgetMapper.selectAdjustmentList(param) == null){

					budgetMapper.deleteAdjustmentM((Map<String, Object>) obj);
					budgetMapper.deleteApprove(params);
				}
    		}
		}

		List resultAmtList = new ArrayList();
		String overbudget="N"; //예산 사용 가능 
		
		//approval table insert
		approvalMap.put("budgetDocNo", budgetDocNo);
		approvalMap.put("userId", params.get("userId"));	
		if(params.get("type").toString().equals("approval")) {
			approvalMap.put("appvStus", "O");	
		} else {
			approvalMap.put("appvStus", "T");	
		}
		approvalMap.put("appvPrcssStus",  "R");	
		approvalMap.put("atchFileGrpId", atchFileGrpId);	
		
		Logger.debug(" type : " + params.get("type").toString()  );
		if(params.get("type").toString().equals("approval")){
			
			List<EgovMap> amtList = budgetMapper.selectAvailableAmtList(approvalMap);		
			
			for(int i=0; i < amtList.size(); i++){
				EgovMap amtMap = amtList.get(i);
				
				if(  Float.parseFloat(amtMap.get("total").toString()) < 0 && Float.parseFloat(amtMap.get("total").toString())*-1 > Float.parseFloat(amtMap.get("availableAmt").toString())){
				
					Logger.debug(" total : " + amtMap.get("total").toString()  );
					Logger.debug(" availableAmt: " + amtMap.get("availableAmt").toString()  );
					
					overbudget = "Y";  //예산 초과
					amtMap.put("overbudget", overbudget);
					
					resultAmtList.add(amtMap);
					continue;
				}					
			}			

			if(overbudget.equals("N")){
				budgetMapper.insertApprove(approvalMap); 
				budgetMapper.updateAdjustmentM(approvalMap); 
			}else{			
				
				params.put("totCnt", addCnt+updCnt+delCnt);
				params.put("budgetDocNo", budgetDocNo.toString());
				params.put("resultAmtList", resultAmtList);
				params.put("overbudget", overbudget);
				throw new ApplicationException("-1","예산초과");				
			}
		}else{			
			/*approvalMap.put("appvStus", "O");							
			approvalMap.put("budgetDocNo", budgetDocNo);
			approvalMap.put("userId", params.get("userId"));
			approvalMap.put("atchFileGrpId", atchFileGrpId);*/
			
			budgetMapper.updateAdjustmentM(approvalMap); 
		}
		
		result.put("totCnt", addCnt+updCnt+delCnt);
		result.put("budgetDocNo", budgetDocNo.toString());
		result.put("resultAmtList", resultAmtList);
		result.put("overbudget", overbudget);
		
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

	@Override
	public EgovMap saveApprovalList(Map<String, Object> params) throws Exception {
		
		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

		EgovMap result = new EgovMap();
		Map approvalMap = new HashMap<String, Object>();

		Object  budgetDocNo = null;
		
		List<Object> updList = (List<Object>) gridData.get(AppConstants.AUIGRID_UPDATE);
		
		List resultAmtList = new ArrayList();
		
		int i = 0;
		
		if(updList.size() > 0){
			
			Logger.debug(" >>>>> updateAdjustmentInfo ");
			
			for (Object obj : updList) 
			{
				if("Y".equals(((Map<String, Object>) obj).get("checkId").toString())){
					
					if(i == 0){
						budgetDocNo = ((Map<String, Object>) obj).get("budgetDocNo");
						i++;
					}else {				
	    				if(budgetDocNo.equals(((Map<String, Object>) obj).get("budgetDocNo"))){
	    					continue;
	    				}else{
	    					budgetDocNo = ((Map<String, Object>) obj).get("budgetDocNo");
	    				}
					}
					
					approvalMap.put("budgetDocNo", budgetDocNo);
					approvalMap.put("userId", params.get("userId"));			
					approvalMap.put("appvStus",  params.get("appvStus"));						
					approvalMap.put("appvPrcssStus",  params.get("appvPrcssStus"));						
					approvalMap.put("rejectMsg",  params.get("rejectMsg"));						
					
					Logger.debug("approvalMap ==================> " + approvalMap);

					String overbudget="N"; //예산 사용 가능 
					if("O".equals(params.get("appvStus").toString())){
						
						List<EgovMap> amtList = budgetMapper.selectAvailableAmtList(approvalMap);		

						for(int j =0; j < amtList.size(); j++){
							EgovMap amtMap = amtList.get(j);
							
							if(  Float.parseFloat(amtMap.get("total").toString()) < 0 && Float.parseFloat(amtMap.get("total").toString())*-1 > Float.parseFloat(amtMap.get("availableAmt").toString())){
							
								Logger.debug(" total : " + amtMap.get("total").toString()  );
								Logger.debug(" availableAmt: " + amtMap.get("availableAmt").toString()  );
								
								overbudget = "Y";  //예산 초과
								amtMap.put("overbudget", overbudget);
								
								resultAmtList.add(amtMap);
								
								continue;
							}			
						}
					}	
					
					if(overbudget.equals("N")){
						budgetMapper.insertApprove(approvalMap); 
						budgetMapper.updateAdjustmentM(approvalMap); 
					}	
					
				}
				
				
			}
		}
		
		result.put("budgetDocNo", budgetDocNo.toString());
		result.put("resultAmtList", resultAmtList);
		//result.put("overbudget", overbudget);

		return result ;
	}
	
	@Override
	public void saveApproval(Map<String, Object> params) throws Exception {
				
		Map approvalMap = new HashMap<String, Object>();
		
		approvalMap.put("budgetDocNo", params.get("pBudgetDocNo"));
		approvalMap.put("userId", params.get("userId"));			
		approvalMap.put("appvStus",  params.get("appvStus"));						
		approvalMap.put("appvPrcssStus",  params.get("appvPrcssStus"));						
		approvalMap.put("rejectMsg",  params.get("rejectMsg"));		
		
		budgetMapper.insertApprove(approvalMap); 
		budgetMapper.updateAdjustmentM(approvalMap); 
	}
	
	@Override
	public List<EgovMap> selectApprovalList( Map<String, Object> params) throws Exception {
		return budgetMapper.selectApprovalList(params);
	}
	
	@Override
	public int selectPlanMaster( Map<String, Object> params) throws Exception {
		return budgetMapper.selectPlanMaster(params);
	}

	@Override
	public String selectCostCenterName(Map<String, Object> params) {
		return budgetMapper.selectCostCenterName(params);
	}

	@Override
	public String selectBudgetCodeName(Map<String, Object> params) {
		return budgetMapper.selectBudgetCodeName(params);
	}

	@Override
	public String selectGlAccCodeName(Map<String, Object> params) {
		return budgetMapper.selectGlAccCodeName(params);
	}

	@Override
	public EgovMap deleteAdjustmentInfo(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

		EgovMap result = new EgovMap();
		List resultList = new ArrayList();
		
		List<Object> updList = (List<Object>) gridData.get(AppConstants.AUIGRID_UPDATE);
		
		Object  budgetDocNo = null;
		
		int i = 0;
		
		Map deleteMap = new HashMap<String, Object>();

		if(updList.size() > 0){
			
			Logger.debug(" >>>>> updateAdjustmentInfo ");
			
			for (Object obj : updList) 
			{		
				if(i == 0){
					budgetDocNo = ((Map<String, Object>) obj).get("budgetDocNo");
					resultList.add(budgetDocNo);
					i++;
				}else {				
    				if(budgetDocNo.equals(((Map<String, Object>) obj).get("budgetDocNo"))){
    					continue;
    				}else{
    					budgetDocNo = ((Map<String, Object>) obj).get("budgetDocNo");
    					resultList.add(budgetDocNo);
    				}
				}
				
				deleteMap.put("budgetDocNo", budgetDocNo);
				
				budgetMapper.deleteAdjustmentM(deleteMap);
				budgetMapper.deleteAdjustmentDByDocNo(deleteMap);
			}
		}
		
		result.put("totCnt", i);
		result.put("resultList", resultList);
		
		return result ;
	}

	@Override
	public String selectCloseMonth(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return budgetMapper.selectCloseMonth(params);
	}

	@Override
	public List<EgovMap> selectAvailableBudgetList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return budgetMapper.selectAvailableBudgetList(params);
	}
}
