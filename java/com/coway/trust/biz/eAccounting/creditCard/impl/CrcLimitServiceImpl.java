package com.coway.trust.biz.eAccounting.creditCard.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.eAccounting.budget.impl.BudgetMapper;
import com.coway.trust.biz.eAccounting.creditCard.CrcLimitService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("crcLimitService")
public class CrcLimitServiceImpl implements CrcLimitService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CrcLimitServiceImpl.class);

    @Resource(name = "crcLimitMapper")
    private CrcLimitMapper crcLimitMapper;

	@Resource(name = "webInvoiceMapper")
	private WebInvoiceMapper webInvoiceMapper;

	@Resource(name = "budgetMapper")
	private BudgetMapper budgetMapper;

    @Override
    public List<EgovMap> selectAllowanceCardList() {
        return crcLimitMapper.selectAllowanceCardList();
    }

    @Override
    public List<EgovMap> selectAllowanceCardPicList() {
        return crcLimitMapper.selectAllowanceCardPicList();
    }

    @Override
    public List<EgovMap> selectAllowanceList(Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {
        LOGGER.debug("========== selectAllowanceList ==========");
        LOGGER.debug("params :: {}", params);

        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
        if(!"A1101".equals(costCentr) && sessionVO.getUserId() != 16178 && sessionVO.getUserId() != 22661)
            params.put("loginUserId", sessionVO.getUserId());

        String[] crcId = request.getParameterValues("crcDropdown");
        params.put("crcId", crcId);

        String[] crcPic = request.getParameterValues("crcPic");
        params.put("crcPic", crcPic);

        return crcLimitMapper.selectAllowanceList(params);
    }

    /*
     * Function applied at CreditCard group of programs
    @Override
    public EgovMap selectAvailableAllowanceAmt(Map<String, Object> params) throws Exception {
        return crcLimitMapper.selectAvailableAllowanceAmt(params);
    }
    */

    @Override
    public List<EgovMap> selectAttachList(String docNo) {
        return crcLimitMapper.selectAttachList(docNo);
    }

    @Override
    public List<EgovMap> selectAdjItems(Map<String, Object> params) {
        return crcLimitMapper.selectAdjItems(params);
    }

    @Override
    public EgovMap getCardInfo(Map<String, Object> params) {
        return crcLimitMapper.getCardInfo(params);
    }

    @Override
    public String saveRequest(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== saveRequest ==========");
        LOGGER.debug("params :: {}", params);

        String docNo = crcLimitMapper.getAdjDocNo();
        int sender = 0;
        int receiver = 0;
        int cnt = 0;

        if("1".equals((String) params.get("adjType")) || "2".equals((String) params.get("adjType"))) {
            // Transfer between Card Holder (1); Transfer between Period (2)
            Map<String, Object> insMap = new HashMap<String, Object>();
            String sAdjPeriod = "";
            String mth = "";
            String year = "";

            insMap.put("docNo", docNo);
            insMap.put("adjType", params.get("adjType"));
            insMap.put("amt", params.get("sAmt"));
            insMap.put("atchFileGrpId", params.get("atchFileGrpId"));
            insMap.put("adjRem", params.get("adjRem"));
            insMap.put("userId", sessionVO.getUserId());

            // Sender
            insMap.put("signal", "-");
            insMap.put("seq", 1);
            insMap.put("crcId", params.get("sCrcHolder"));

            sAdjPeriod = (String) params.get("sPeriod");
            mth = sAdjPeriod.substring(0, 2);
            year = sAdjPeriod.substring(3);

            insMap.put("month", mth);
            insMap.put("year", year);

            sender = crcLimitMapper.insertAdj_FCM33D(insMap);

            // Receiver
            insMap.put("signal", "+");
            insMap.put("seq", 2);
            insMap.put("crcId", params.get("rCrcHolder"));

            sAdjPeriod = (String) params.get("rPeriod");
            mth = sAdjPeriod.substring(0, 2);
            year = sAdjPeriod.substring(3);

            insMap.put("month", mth);
            insMap.put("year", year);

            receiver = crcLimitMapper.insertAdj_FCM33D(insMap);


        } else if("3".equals((String) params.get("adjType")) || "4".equals((String) params.get("adjType"))) {
            // Addition (3); Deduction (4)
            Map<String, Object> insMap = new HashMap<String, Object>();

            insMap.put("docNo", docNo);
            insMap.put("atchFileGrpId", params.get("atchFileGrpId"));
            insMap.put("amt", params.get("sAmt"));
            insMap.put("atchFileGrpId", params.get("atchFileGrpId"));
            insMap.put("adjRem", params.get("adjRem"));
            insMap.put("userId", sessionVO.getUserId());

            if("3".equals((String) params.get("adjType"))) {
                insMap.put("signal", "+");
                insMap.put("adjType", params.get("adjType"));
                insMap.put("amt", params.get("rAmt"));
                insMap.put("crcId", params.get("rCrcHolder"));

            } else if("4".equals((String) params.get("adjType"))) {
                insMap.put("signal", "-");
                insMap.put("adjType", params.get("adjType"));
                insMap.put("amt", params.get("sAmt"));
                insMap.put("crcId", params.get("sCrcHolder"));
            }

            String sAdjPeriod = ("3".equals((String) params.get("adjType"))) ? (String) params.get("rPeriod") : (String) params.get("sPeriod");
            int startAdjMth = Integer.parseInt(sAdjPeriod.substring(0, 2));
            int year = Integer.parseInt(sAdjPeriod.substring(3));
            insMap.put("year", year);

            // int seq = 1;

            insMap.put("seq", 1);
            insMap.put("month", startAdjMth);

            cnt = crcLimitMapper.insertAdj_FCM33D(insMap);

            /*
            for(int i = startAdjMth; i <= 12; i++) {
                insMap.put("seq", seq);
                insMap.put("month", startAdjMth);

                cnt = crcLimitMapper.insertAdj_FCM33D(insMap);

                seq++;
                cnt++;
            }
            */
        }

        if("1".equals((String) params.get("adjType")) || "2".equals((String) params.get("adjType"))) {
            if(sender <= 0 || receiver <= 0) {
                docNo = "";
            }
        } else {
            if(cnt <= 0) {
                docNo = "";
            }
        }

        return docNo;
    }

    @Override
    public List<EgovMap> selectAdjustmentList(Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {
        LOGGER.debug("========== selectAdjustmentList ==========");
        LOGGER.debug("params :: {}", params);
        //Allowing Budget Team to see all records only
    	params.put("userId", sessionVO.getUserId());
        List<EgovMap> budgetTeamList = budgetMapper.getListPermAppr(params);

        if(budgetTeamList.size() == 0){
        	params.put("loginUserId", sessionVO.getUserId());
        }

        String[] adjType = request.getParameterValues("selAdjType");
        params.put("adjType", adjType);

        String[] crcId = request.getParameterValues("crcDropdown");
        params.put("crcId", crcId);

        String[] status = request.getParameterValues("status");
        params.put("status", status);

        return crcLimitMapper.selectAdjustmentList(params);
    }
    @Override
    public String editRequest(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== editRequest ==========");
        LOGGER.debug("params :: {}", params);
        String sPeriod = params.get("sPeriod").toString();
        String rPeriod = params.get("rPeriod").toString();

        params.put("userId", sessionVO.getUserId());
        if(!CommonUtils.isEmpty(sPeriod)){
            params.put("sPeriodMonth",sPeriod.substring(0,2));
            params.put("sPeriodYear",sPeriod.substring(3));
        }
        if(!CommonUtils.isEmpty(rPeriod)){
            params.put("rPeriodMonth",rPeriod.substring(0,2));
            params.put("rPeriodYear",rPeriod.substring(3));
        }

        crcLimitMapper.updateSenderApp_FCM33D(params);
        crcLimitMapper.updateReceiverApp_FCM33D(params);

        String docNo = (String) params.get("adjNo");
        return docNo;
    }

    @Override
    public String deleteRequest(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== deleteRequest ==========");
        LOGGER.debug("params :: {}", params);

        EgovMap attachmentDetail = crcLimitMapper.selectAtchFile(params);

        if(attachmentDetail != null){
            String atchFileGrpId = params.get("atchFileGrpId").toString();
            String atchFileId = attachmentDetail.get("atchFileId").toString();

            params.put("atchFileId", atchFileId);
            crcLimitMapper.deleteAttachment_SYS71D(params);
            crcLimitMapper.deleteAttachment_SYS70M(params);
        }

        String docNo = (String) params.get("adjNo");
        crcLimitMapper.deleteApp_FCM33D(params);
        return docNo;
    }

    @Override
    public int submitAdjustment(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== submitAdjustment ==========");
        LOGGER.debug("params :: {}", params);

        params.put("userId", sessionVO.getUserId());

        int action = crcLimitMapper.insertApp_FCM34D(params);

        return action;
    }

    @Override
    public List<EgovMap> selectAdjustmentAppvList(Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {
        LOGGER.debug("========== selectAdjustmentAppvList ==========");
        LOGGER.debug("params :: {}", params);
        //Allowing Budget Team to see all records only
    	params.put("userId", sessionVO.getUserId());
        List<EgovMap> budgetTeamList = budgetMapper.getListPermAppr(params);

        if(budgetTeamList.size() == 0){
        	params.put("loginUserId", sessionVO.getUserId());
        }
        else{

        }

        String[] adjType = request.getParameterValues("adjType");
        params.put("adjType", adjType);

        String[] crcId = request.getParameterValues("crcDropdown");
        params.put("crcId", crcId);

        return crcLimitMapper.selectAdjustmentAppvList(params);
    }

    @Override
    public int approvalUpdate(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== approvalUpdate ==========");
        LOGGER.debug("params :: {}", params);

        int appCnt = 0;

        if(params.containsKey("grid")) {
            // Multiple
            List<Object> grid = (List<Object>) params.get("grid");
            for(int i = 0; i < grid.size(); i++) {
                Map<String, Object> gridItem = (Map<String, Object>) grid.get(i);

                Map<String, Object> appParam = new HashMap<String, Object>();
                appParam.put("adjNo", gridItem.get("adjNo"));
                appParam.put("action", params.get("action"));
                appParam.put("userId", sessionVO.getUserId());
                appParam.put("appvLineSeq", gridItem.get("appvLineSeq"));

                if("J".equals((String) params.get("action"))) {
                    appParam.put("rejctResn", params.get("rejctResn"));
                }

                crcLimitMapper.updateApp_FCM34D(appParam);
                this.updateMasterApprovalLineStatus(appParam);
                appCnt += 1;
            }
        } else {
            // Single
            params.put("userId", sessionVO.getUserId());
            crcLimitMapper.updateApp_FCM34D(params);
            appCnt += 1;
            this.updateMasterApprovalLineStatus(params);
        }

        return appCnt;
    }

    private int updateMasterApprovalLineStatus(Map<String, Object> params){
    	//get user current approval line count and overall adjustment number total approval line count
    	EgovMap countInfo = crcLimitMapper.selectTotalAppLineStusCountInfo(params);

    	int userApprovalLineCount = Integer.parseInt(params.get("appvLineSeq").toString());
    	int totalApprovalLineCount = Integer.parseInt(countInfo.get("appvLineCnt").toString());

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("adjNo", params.get("adjNo"));
        param.put("userId", params.get("userId"));

        //reject handling
        if(params.get("action").toString().equals("J")){
    		param.put("appvLinePrcssCnt", userApprovalLineCount);
    		param.put("currAppvPrcssStus", params.get("action"));
    		crcLimitMapper.updateAppLineStus_FCM33D(param);
        }
        else{
        	if(userApprovalLineCount < totalApprovalLineCount){
        		param.put("appvLinePrcssCnt", userApprovalLineCount + 1);
        		param.put("currAppvPrcssStus", "P");
        		crcLimitMapper.updateAppLineStus_FCM33D(param);
        	}
        	else{
        		param.put("appvLinePrcssCnt", userApprovalLineCount);
        		param.put("currAppvPrcssStus", params.get("action"));
        		crcLimitMapper.updateAppLineStus_FCM33D(param);
        	}
        }
    	return 1;
    }

    @Override
	public List<EgovMap> selectCardholderPendingAmountList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return crcLimitMapper.selectCardholderPendingAmountList(params);
	}

	@Override
	public List<EgovMap> selectCardholderUtilisedAmountList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return crcLimitMapper.selectCardholderUtilisedAmountList(params);
	}

	@Override
	public List<EgovMap> selectCardholderApprovedAdjustmentLimitList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return crcLimitMapper.selectCardholderApprovedAdjustmentLimitList(params);
	}

    @Override
    public EgovMap getFinApprover(Map<String, Object> params) {
        return webInvoiceMapper.getFinApprover(params);
    }

    @Override
    public int checkExistAdjNo(String adjNo) {
        return crcLimitMapper.checkExistAdjNo(adjNo);
    }

    @Override
    public List<String> saveRequestBulk(Map<String, Object> params, SessionVO sessionVO) {
    	List<String> documentNumberList = new ArrayList<String>();
    	List<Object> adjGridList = (List<Object>) params.get("adjGridList");
    	if (adjGridList.size() > 0) {
			Map hm = null;

			for (Object map : adjGridList) {
				hm = (HashMap<String, Object>) map;

				documentNumberList.add(this.saveRequest(hm, sessionVO));
			}
		}
    	return documentNumberList;
    }

    @Override
    public int saveApprovalLineBulk(Map<String, Object> params, SessionVO sessionVO) {
    	List<String> documentNumberList = (List<String>) params.get("documentNumberList");
    	List<Object> apprGridList = (List<Object>) params.get("apprGridList");

		params.put("appvLineCnt", apprGridList.size());

		if (documentNumberList.size() > 0) {
			if (apprGridList.size() > 0) {
				Map hm = null;
				for(int i = 0; i < documentNumberList.size();i++){
					for (Object map : apprGridList) {
						hm = (HashMap<String, Object>) map;
						hm.put("docNo", documentNumberList.get(i).toString());
						hm.put("userId", sessionVO.getUserId());

						int approverUserId = crcLimitMapper.selectUserIdWithHrCode(hm);
						hm.put("apprUserId", approverUserId);
						crcLimitMapper.insertApp_FCM34D_Approval_Line(hm);
					}


					Map fcm0033Param = new HashMap<String,Object>();
					fcm0033Param.put("docNo", documentNumberList.get(i).toString());
					fcm0033Param.put("appvLineCnt", apprGridList.size());
					fcm0033Param.put("appvLinePrcssCnt", 1);
					fcm0033Param.put("currAppvPrcssStus", "R");
					fcm0033Param.put("userId", sessionVO.getUserId());

					crcLimitMapper.updateApp_FCM33D_Approval_Line(fcm0033Param);
				}
			}
		}

		return 1;
    }

    @Override
    public String submitNewAdjustmentWithApprovalLine(Map<String, Object> params, SessionVO sessionVO) {
    	List<String> documentNumberList = this.saveRequestBulk(params, sessionVO);
    	if (documentNumberList.size() > 0) {
    		params.put("documentNumberList", documentNumberList);
    		this.saveApprovalLineBulk(params, sessionVO);
    	}
    	return String.join(",", documentNumberList);
    }

    @Override
    public List<EgovMap> getApprovalLineDescriptionInfo(Map<String, Object> params) {
        return crcLimitMapper.getApprovalLineDescriptionInfo(params);
    }


    @Override
    public int checkCurrAppvLineIsBudgetTeam(Map<String, Object> params) {
        return crcLimitMapper.checkCurrAppvLineIsBudgetTeam(params);
    }

    @Override
    public List<EgovMap> selectApprovalLineForEdit(Map<String, Object> params) {
        return crcLimitMapper.selectApprovalLineForEdit(params);
    }

    @Override
    public int editApprovalLineSubmit(Map<String, Object> params, SessionVO sessionVO) {
    	List<Object> apprGridList = (List<Object>) params.get("apprGridList");
    	if (apprGridList.size() > 0) {
			for (Object map : apprGridList) {
				Map hm = null;
				hm = (HashMap<String, Object>) map;

				String appvStus = "";

				if(hm.get("appvStus") != null){
					appvStus = hm.get("appvStus").toString();
				}

				hm.put("userId", sessionVO.getUserId());
				hm.put("apprUserId", crcLimitMapper.selectUserIdWithHrCode(hm));
				hm.put("docNo", params.get("docNo"));
				crcLimitMapper.updateApp_FCM34D_Approval_Line(hm);
			}
			Map<String,Object> approvalLineDetail = new HashMap<String, Object>();
			approvalLineDetail.put("docNo", params.get("docNo"));
			approvalLineDetail.put("appvLineCnt", apprGridList.size());
			approvalLineDetail.put("userId", sessionVO.getUserId());
			crcLimitMapper.deleteApp_FCM34D_Excess_Approval_Line(approvalLineDetail);
			crcLimitMapper.updateApp_FCM33D_Approval_Line_Count(approvalLineDetail);
		}
    	return 1;
    }
}
