package com.coway.trust.biz.eAccounting.budget.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.commons.collections.map.ListOrderedMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.eAccounting.budget.BudgetService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sales.ccp.impl.CcpAgreementServieImpl;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
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
	public List<EgovMap> selectAdjustmentCBGCostCenter(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return budgetMapper.selectAdjustmentCBGCostCenter(params);
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

		//int grpSeq = budgetMapper.getGrpSeq(params);

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
				//((Map<String, Object>) obj).put("budgetGrpSeq", grpSeq);

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

				Map ntf = new HashMap<String, Object>();
				ntf.put("code", "Budget");
				ntf.put("codeName", "Budget Adjustment");
				ntf.put("clmNo", budgetDocNo.toString());
				ntf.put("appvStus", "R");
				ntf.put("rejctResn", "Pending Approval.");
				ntf.put("reqstUserId", "BUDGET");
				ntf.put("userId", params.get("userId"));

				webInvoiceMapper.insertNotification(ntf);
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

					if("J".equals(params.get("appvPrcssStus").toString())) {
					    Map ntf = new HashMap<String, Object>();

					    ntf.put("budgetDocNo", budgetDocNo.toString());
					    String reqstName = budgetMapper.getReqDtl(ntf);

					    ntf.put("code", "Budget");
		                ntf.put("codeName", "Budget Adjustment");
		                ntf.put("clmNo", budgetDocNo.toString());
		                ntf.put("appvStus", "J");
		                ntf.put("rejctResn", params.get("rejectMsg"));
		                ntf.put("reqstUserId", reqstName);
		                ntf.put("userId", params.get("userId"));

		                webInvoiceMapper.insertNotification(ntf);
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
				int cnt = budgetMapper.getBudgetDocNoFCM0039D_2(deleteMap);
				if(cnt > 0){
					budgetMapper.removeFCM0039D_delete(deleteMap);
				}
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

    @Override
    public EgovMap availableAmtCp(Map<String, Object> params) {
        return budgetMapper.availableAmtCp(params);
    }

    @Override
    public EgovMap checkBgtPlan(Map<String, Object> params) {
        return budgetMapper.checkBgtPlan(params);
    }

    @Override
    public EgovMap getAdjInfo(Map<String, Object> params) {
        return budgetMapper.getAdjInfo(params);
    }

    @Override
    public EgovMap getBgtApprList(Map<String, Object> params) {
        return budgetMapper.getBgtApprList(params);
    }

    @Override
    public List<EgovMap> getPermRole() {
        return budgetMapper.getPermRole();
    }

    @Override
    public List<EgovMap> getListPerm(Map<String, Object> params) {
        return budgetMapper.getListPerm(params);
    }

    @Override
    public List<EgovMap> getListPermAppr(Map<String, Object> params) {
    	return budgetMapper.getListPermAppr(params);
    }

    @Override
    public Map<String, Object> uploadBudgetAdjustment(Map<String, Object> formData, List<Object> itemList) throws Exception {
      // TODO Auto-generated method stub
    	Logger.debug("uploadBudgetAdjustment :::: itemList {} ", itemList);

        String uploadAdjNo = budgetMapper.selectUploadAdjNo();
      	List budgetDocNoList = new ArrayList();
      	List overBudgetList = new ArrayList();

      	Object  atchFileGrpId = formData.get("atchFileGrpId");
      	List<Object> resultAddList = new ArrayList();

          // insert FCM0039D
          if (itemList.size() > 0) {
            HashMap<String, Object> hm = null;
            for (Object map : itemList) {
              hm = (HashMap<String, Object>) map;
              hm.put("uploadAdjNo", uploadAdjNo);
              hm.put("crtUserId", formData.get("crtUserId"));
              hm.put("updUserId", formData.get("updUserId"));
              budgetMapper.insertUploadAdjustmentT(hm);

            }
          }


        Map<String, Object> reMap = new HashMap();
        Map<String, Object> updateMap = new HashMap();
        Map<String, Object> testMap = new HashMap();
        Map<String, Object> deMap = new HashMap();


        reMap.put("uploadAdjNo", uploadAdjNo);
      	int compareKey = 1;

        List<EgovMap> uploadMasterList = budgetMapper.getUploadMasterList(reMap);
        List resultList = new ArrayList();

        String failMsg = "";

      	List adjList = null;
      	int cnt = 0;
      	Logger.debug("uploadBudgetAdjustment :::: uploadMasterList {} ", uploadMasterList);
      	 int addCnt=0;
      	 int addTurn = 0;
          if (uploadMasterList.size() > 0) {

          	Object  budgetDocNo = "";

            for (int a = 0; a < uploadMasterList.size(); a++) {
             reMap = uploadMasterList.get(a);
             Logger.debug("reMap >>> " + reMap.get("adjNumber"));
              reMap.put("uploadAdjNo", uploadAdjNo);

      				reMap.put("adjNumber", compareKey);
      				List<EgovMap> uploadNewMasterList = budgetMapper.getUploadNewMasterList(reMap);
      				Logger.debug("uploadNewMasterList {} >>>" + uploadNewMasterList);
      				if (uploadNewMasterList.size() > 0) {

      					for (int i = 0; i < uploadNewMasterList.size(); i++) {
      					reMap = uploadNewMasterList.get(i);
      					Logger.debug("reMap 2 >>> " + reMap);
      					reMap.put("uploadAdjNo", uploadAdjNo);
      					reMap.put("crtUserId", formData.get("crtUserId"));
      					reMap.put("updUserId", formData.get("updUserId"));
      					reMap.put("costCenter", reMap.get("costCentr"));
      					if (checkPlanMaster(reMap) < 1) {

      						 String msgs = "";
         					 String budgetCd = (String) reMap.get("budgetCode");
         					 String glAccCode = (String) reMap.get("glAccCode");
         					 String rs =  compareKey +",";
         					 failMsg += rs;
         					 if(!reMap.get("budgetAdjType").equals("01")|| !reMap.get("budgetAdjType").equals("02")){
         						 reMap.put("adjNumber", compareKey);
         						 Logger.debug("adjNumber: " + reMap.get("adjNumber") );
         						int count = budgetMapper.getBudgetDocNoFCM0039D_1(reMap);

         						if(count > 0){
         							String budgetNo = budgetMapper.getBudgetDocNoFCM0039D(reMap);
         							Logger.debug("Budget Doc No: " + budgetNo);
         							reMap.put("budgetDocNo", budgetNo);
         							budgetDocNoList.remove(budgetNo);
         							removeAdjustmentD(reMap);
         							removeAdjustmentM(reMap);
         						}
         						removeFCM0039D(reMap);
     							i = uploadNewMasterList.size();
         					 }

      					} else {
      						Logger.debug("uploadAdjNo :::: reMap {} ", reMap);
      						deMap.put("year", reMap.get("adjYearMonth").toString().substring(3));
      						String month = reMap.get("adjYearMonth").toString().substring(0,2);
      						//String month = "";
      						/*if(monthTemp.length() == 2 && monthTemp.substring(0, 1).equals("0")){
      							month = reMap.get("adjYearMonth").toString().substring(1,2);
      						}else{*/
      						//	month = reMap.get("adjYearMonth").toString().substring(0,2);
      						//}
							deMap.put("month", month);
							deMap.put("costCentr", reMap.get("costCentr"));
							deMap.put("budgetCode", reMap.get("budgetCode"));
							deMap.put("glAccCode", reMap.get("glAccCode"));

							EgovMap availableAmtt = new EgovMap();
							availableAmtt = budgetMapper.getBudgetAmt(deMap);
							if(!reMap.get("budgetAdjType").equals("01") && reMap.get("signal").equals("-") && Float.parseFloat(reMap.get("adjAmt").toString()) > Float.parseFloat(availableAmtt.get("availableAmt").toString())){
								reMap.put("adjNumber", compareKey);
								if(!overBudgetList.contains(compareKey)){
									overBudgetList.add(compareKey);
      							}

								int count = budgetMapper.getBudgetDocNoFCM0039D_1(reMap);

								if(count > 0){
									String bdgDocNo = "";
									bdgDocNo = budgetMapper.getBudgetDocNoFCM0039D(reMap);
									reMap.put("budgetDocNo", bdgDocNo);
				      				removeAdjustmentD(reMap);
         							removeAdjustmentM(reMap);
				      				budgetDocNoList.remove(bdgDocNo);
								}
								removeFCM0039D(reMap);
								i = uploadNewMasterList.size();

							}else{
								reMap.put("adjNumber", compareKey);
								float sumAdj = 0;
								sumAdj = budgetMapper.checkUploadSum(reMap);

								if(sumAdj > Float.parseFloat(availableAmtt.get("availableAmt").toString())){

									if(!overBudgetList.contains(compareKey)){
										overBudgetList.add(compareKey);
	      							}

									int count = budgetMapper.getBudgetDocNoFCM0039D_1(reMap);

									if(count > 0){
										String bdgDocNo = "";
										bdgDocNo = budgetMapper.getBudgetDocNoFCM0039D(reMap);
										reMap.put("budgetDocNo", bdgDocNo);
					      				removeAdjustmentD(reMap);
	         							removeAdjustmentM(reMap);
					      				budgetDocNoList.remove(bdgDocNo);
									}
									removeFCM0039D(reMap);
									i = uploadNewMasterList.size();
								}else{
              						((Map<String, Object>) reMap).put("userId", formData.get("updUserId"));
              						addCnt++;
              						addTurn++;

              						if(addTurn == 1){

              							((Map<String, Object>) reMap).put("atchFileGrpId", formData.get("atchFileGrpId"));

              							//master table insert
              							budgetMapper.insertAdjustmentM((Map<String, Object>) reMap);

              							budgetDocNo = (String) ((Map<String, Object>) reMap).get("budgetDocNo");
              							if(!budgetDocNoList.contains(budgetDocNo)){
              								budgetDocNoList.add(budgetDocNo);
              							}

              						}

              						((Map<String, Object>) reMap).put("budgetDocNo", budgetDocNo);

              						//detail table insert
              						budgetMapper.insertAdjustmentD((Map<String, Object>) reMap);

              						reMap.put("adjNumber", compareKey);

              						budgetMapper.updateFCM0039D(reMap);
								}
							}
      					}

      				}
      					addTurn = 0;

      			}


      			++compareKey;
      			Logger.debug("Current compareKey: " + compareKey);
            }


          } else {
            // remove the data from LOG0112D
            removeFCM0039D(reMap);

            formData.put("message", "Error. No data inserted");
          }

        Map approvalMap = new HashMap<String, Object>();

      	for(int i = 0; i < budgetDocNoList.size(); i++){
      		EgovMap result = new EgovMap();
      		List resultAmtList = new ArrayList();
      		String overbudget="N"; //예산 사용 가능
      		Map getMap = new HashMap<String, Object>();
      		//approval table insert
      		approvalMap.put("budgetDocNo", budgetDocNoList.get(i));
      		approvalMap.put("userId", formData.get("crtUserId"));
      		approvalMap.put("appvStus", "O");
      		approvalMap.put("appvPrcssStus",  "R");
      		approvalMap.put("atchFileGrpId", atchFileGrpId);

      				budgetMapper.insertApprove(approvalMap);
      				budgetMapper.updateAdjustmentM(approvalMap);

      				Map ntf = new HashMap<String, Object>();
      				ntf.put("code", "Budget");
      				ntf.put("codeName", "Budget Adjustment");
      				ntf.put("clmNo", budgetDocNoList.get(i).toString());
      				ntf.put("appvStus", "R");
      				ntf.put("rejctResn", "Pending Approval.");
      				ntf.put("reqstUserId", "BUDGET");
      				ntf.put("userId", formData.get("crtUserId"));

      				webInvoiceMapper.insertNotification(ntf);


      			getMap.put("budgetDocNo", budgetDocNoList.get(i).toString());
      			String str = budgetMapper.getAdjNumber(getMap);
      			String outputDocNo = "[" + budgetDocNoList.get(i).toString() + ", Adj No:" + str + "]\n";
      			result.put("totCnt", addCnt);
      			result.put("budgetDocNo", outputDocNo);
      			result.put("resultAmtList", resultAmtList);
      			result.put("overbudget", overbudget);

      			resultAddList.add(result);
      		}

      	String res = "";
      	if(failMsg.length() > 0){
      		failMsg = failMsg.substring(0, failMsg.length() - 1);
      		res += "Budget Code-GL Acc Code not in yearly plan: \nAdj No:" + failMsg + "\n";
      	}

      	if(overBudgetList.size() > 0){
      		String overbdgt = "";
      		for(int i = 0; i < overBudgetList.size(); i++){
      			overbdgt += overBudgetList.get(i) + ",";
      		}
      		overbdgt = overbdgt.substring(0, overbdgt.length() - 1);
      		res += "Overbudget:\nAdj No: " + overbdgt;
      	}

      	formData.put("message", res);
      	formData.put("resultList", resultAddList);

        return formData;
    }

    @Override
	public String selectAdjType(String params) {
		// TODO Auto-generated method stub
		return budgetMapper.selectAdjType(params);
	}


    @Override
	public List<EgovMap> selectBudgetCodeList(Map<String, Object> params) throws Exception {
		return budgetMapper.selectBudgetCodeList(params);
	}

    private int checkPlanMaster(Map<String, Object> reMap) throws Exception {
        int resultCnt = budgetMapper.selectBudgetPlan(reMap);

        return resultCnt;
      }

    @Override
	public int updateBudgetCode(List<Object> updList, SessionVO sessionVO) {

		int updCnt	= 0;
		int updUserId	= sessionVO.getUserId();
		//int stusCode = updList.g

		try {
			for ( Object obj : updList ) {
				((Map<String, Object>) obj).put("updUserId", updUserId);
				budgetMapper.updateBudgetCode((Map<String, Object>) obj);
				updCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		return	updCnt;
	}

    public List<EgovMap> selectBudgetAdjustmentConflict(Map<String, Object> params){
  	  return budgetMapper.selectBudgetAdjustmentConflict(params);
    }

    private void removeFCM0039D(Map<String, Object> reMap) {
        // TODO Auto-generated method stub
        budgetMapper.removeFCM0039D(reMap);
      }

   private int checkBudget(Map<String, Object> reMap) throws Exception {
        // TODO Auto-generated method stub
	   int result = budgetMapper.getBudgetAvailable(reMap);
	   return result;
      }

   public List<EgovMap> selectStatusList() {
		// TODO Auto-generated method stub
		return budgetMapper.selectStatusList();
	}

   public List<EgovMap> selectExpenseTyp() {
		// TODO Auto-generated method stub
		return budgetMapper.selectExpenseTyp();
	}

   private void removeAdjustmentD(Map<String, Object> reMap) {
       // TODO Auto-generated method stub
       budgetMapper.removeAdjustmentD(reMap);
     }

   private void removeAdjustmentM(Map<String, Object> reMap) {
       // TODO Auto-generated method stub
       budgetMapper.removeAdjustmentM(reMap);
     }

   private void checkUploadSum(Map<String, Object> reMap) {
       // TODO Auto-generated method stub
       budgetMapper.checkUploadSum(reMap);
     }

}
