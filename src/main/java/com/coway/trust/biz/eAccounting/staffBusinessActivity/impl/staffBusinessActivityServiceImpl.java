package com.coway.trust.biz.eAccounting.staffBusinessActivity.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.eAccounting.staffBusinessActivity.staffBusinessActivityService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("staffBusinessActivityService")
public class staffBusinessActivityServiceImpl implements staffBusinessActivityService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

    @Resource(name = "staffBusinessActivityMapper")
    private staffBusinessActivityMapper staffBusinessActivityMapper;

    @Resource(name = "webInvoiceMapper")
    private WebInvoiceMapper webInvoiceMapper;

    @Override
    public EgovMap getAdvConfig(Map<String, Object> params) {
        return staffBusinessActivityMapper.getAdvConfig(params);
    }

    @Override
    public EgovMap getRqstInfo(Map<String, Object> params) {
        return staffBusinessActivityMapper.getRqstInfo(params);
    }

    @Override
    public EgovMap getAdvClmInfo(Map<String, Object> params) {
        return staffBusinessActivityMapper.getAdvClmInfo(params);
    }

    @Override
	public List<EgovMap> selectAdvOccasions(Map<String, Object> params) {
		return staffBusinessActivityMapper.selectAdvOccasions(params);
	}

	public List<EgovMap> selectAdvOccasions2(Map<String, Object> params) {
		return staffBusinessActivityMapper.selectAdvOccasions2(params);
	}

    @Override
    public String selectNextClmNo(Map<String, Object> params) {
        return staffBusinessActivityMapper.selectNextClmNo(params);
    }

    @Override
    public void insertRequest(Map<String, Object> params) {
    	staffBusinessActivityMapper.insertRequest(params);
    }

    @Override
	public List<EgovMap> getRefDtlsGrid(String clmNo) {
		// TODO Auto-generated method stub
		return staffBusinessActivityMapper.getRefDtlsGrid(clmNo);
	}

    @Override
	public EgovMap selectClamUn(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return staffBusinessActivityMapper.selectClamUn(params);
	}

    @Override
	public void updateClamUn(Map<String, Object> params) {
		// TODO Auto-generated method stub
    	staffBusinessActivityMapper.updateClamUn(params);
	}

    @Override
    public void insertTrvDetail(Map<String, Object> params) {

    	LOGGER.debug("insertBusinessActivity=====================================>>  " + params);

		staffBusinessActivityMapper.insertRefund(params);

		if(params.get("advType").equals("4"))
		{
    		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

    		List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기
    		LOGGER.debug("gridData AddList: =====================================>> " + addList);

    		if (addList.size() > 0) {
    			Map hm = null;
    			// biz처리
    			for (Object map : addList) {
    				hm = (HashMap<String, Object>) map;
    				hm.put("clmNo", (String) params.get("clmNo"));
    				int clmSeq = staffBusinessActivityMapper.selectNextClmSeq((String) params.get("clmNo"));
    				hm.put("clmSeq", clmSeq);
    				hm.put("clmType", "A2");
    				hm.put("userId", params.get("userId"));
    				hm.put("expType", params.get("expType"));
    				hm.put("expTypeNm", params.get("expTypeNm"));
    				hm.put("advType", params.get("advType"));
    				hm.put("dAmt", ((Map<String, Object>) map).get("totAmt"));
    				LOGGER.debug("insertBusinessActivityDetail =====================================>>  " + hm);
    				staffBusinessActivityMapper.insertTrvDetail(hm);
    			}
    		}
    		LOGGER.info("추가 : {}", addList.toString());

		}
		else
		{
			staffBusinessActivityMapper.insertTrvDetail(params);
		}

    }

    @Override
    public void insertApproveManagement(Map<String, Object> params) {
    	webInvoiceMapper.insertApproveManagement(params);
    }

    @Override
    public void insertApproveLineDetail(Map<String, Object> params) {
    	webInvoiceMapper.insertApproveLineDetail(params);
    }

    @Override
    public void editDraftRequestM(Map<String, Object> params) {
    	staffBusinessActivityMapper.editDraftRequestM(params);
    }

    @Override
    public void editDraftRequestD(Map<String, Object> params) {
    	LOGGER.debug("editDraftRequestD Before =====================================>>  " + params);

    	if(params.get("advType").equals("4"))
		{
        	Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");
        	List<Object> updateList = (List<Object>) gridData.get("update");
        	if (updateList.size() > 0) {
    			Map hm = null;

    			for (Object map : updateList) {
    				hm = (HashMap<String, Object>) map;
    				hm.put("clmNo", params.get("clmNo"));
    				hm.put("userId", params.get("userId"));
    				hm.put("advType", params.get("advType"));
    				hm.put("dAmt", params.get("refTotExp"));
    				hm.put("expType", params.get("expType"));
    				hm.put("expTypeNm", params.get("expTypeNm"));
    				LOGGER.debug("editDraftRequestD After =====================================>>  " + hm);
    				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
    				staffBusinessActivityMapper.editDraftRequestD(hm);
    			}
    		}

        	List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기
    		LOGGER.debug("gridData AddList: =====================================>> " + addList);

    		if (addList.size() > 0) {
    			Map hm = null;
    			// biz처리
    			for (Object map : addList) {
    				hm = (HashMap<String, Object>) map;
    				hm.put("clmNo", (String) params.get("clmNo"));
    				int clmSeq = staffBusinessActivityMapper.selectNextClmSeq((String) params.get("clmNo"));
    				hm.put("clmSeq", clmSeq);
    				hm.put("clmType", "A2");
    				hm.put("userId", params.get("userId"));
    				hm.put("expType", params.get("expType"));
    				hm.put("expTypeNm", params.get("expTypeNm"));
    				hm.put("advType", params.get("advType"));
    				hm.put("dAmt", params.get("totAmt"));
    				String clmNo = (String) params.get("clmNo");
    				/*if(clmNo.substring(0, 2).equals("A2"))
    				{
    					hm.put("glAccCode", params.get("glAccCode"));
        				hm.put("glAccNm", params.get("glAccCodeName"));
        				hm.put("budgetCode", params.get("budgetCode"));
        				hm.put("budgetCodeNm", params.get("budgetCodeName"));
    				}*/
    				LOGGER.debug("editDraftRequestD =====================================>>  " + hm);
    				staffBusinessActivityMapper.editDraftRequestD(hm);
    			}
    		}

    		List<Object> removeList = (List<Object>) gridData.get("remove"); // 추가 리스트 얻기
    		LOGGER.debug("gridData RemoveList: =====================================>> " + removeList);

    		if (removeList.size() > 0) {
    			Map hm = null;
    			// biz처리
    			for (Object map : removeList) {
    				hm = (HashMap<String, Object>) map;
    				hm.put("clmNo", (String) params.get("clmNo"));
    				hm.put("clmaUn", params.get("clamUn"));
    				LOGGER.debug("deleteDraftRequestD =====================================>>  " + hm);
    				staffBusinessActivityMapper.deleteDraftRequestD(hm);
    			}
    		}
		}
    	else
		{
    		staffBusinessActivityMapper.editDraftRequestD(params);
		}
    }

    @Override
    public void updateTotal(Map<String, Object> params) {
    	staffBusinessActivityMapper.updateTotal(params);
    }

    @Override
    public void insMissAppr(Map<String, Object> params) {
        webInvoiceMapper.insMissAppr(params);
    }

    @Override
    public EgovMap getClmDesc(Map<String, Object> params) {
        return webInvoiceMapper.getClmDesc(params);
    }

    @Override
    public EgovMap getNtfUser(Map<String, Object> params) {
        return webInvoiceMapper.getNtfUser(params);
    }

    @Override
    public void insertAppvDetails(Map<String, Object> params) {
    	if(params.get("advType").equals("4"))
		{
   		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");
    		//List<Object> gridData = (List<Object>) params.get("gridData");
//    		List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기
   		List<Object> itemGrid= null;
   		if((List<Object>) gridData.get("add") != null)
   		{
   			itemGrid = (List<Object>) gridData.get("add");
   		}
   		else if((List<Object>)gridData.get(AppConstants.AUIGRID_ALL) != null)
   		{
   			itemGrid = (List<Object>)gridData.get(AppConstants.AUIGRID_ALL);
   		}

    	LOGGER.debug("gridData gridData: =====================================>> " + gridData);
    	LOGGER.debug("gridData itemGrid: =====================================>> " + itemGrid);

    		if (gridData.size() > 0) {
    			Map hm = null;
    			// biz처리
    			for (Object map : itemGrid) {
    				hm = (HashMap<String, Object>) map;
    				hm.put("clmNo", (String) params.get("clmNo"));
    				int clmSeq = staffBusinessActivityMapper.selectNextClmSeq((String) params.get("clmNo"));
    				hm.put("clmSeq", clmSeq);
    				hm.put("appvItmSeq", "1");
    				hm.put("clmType", "A2");
    				hm.put("userId", params.get("userId"));
    				hm.put("expType", params.get("advType"));
    				hm.put("expTypeNm", params.get("expTypeNm"));
    				hm.put("advType", params.get("advType"));
    				hm.put("amt", ((Map<String, Object>) map).get("totAmt"));
    				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
    				hm.put("memAccId", params.get("memAccId"));
    				hm.put("costCenter", params.get("costCenter"));
                	hm.put("glAccNo",((Map<String, Object>) map).get("glAccCode"));
                	hm.put("glAccNm",((Map<String, Object>) map).get("glAccCodeName"));
                	hm.put("atchFileGrpId", params.get("atchFileGrpId"));
    				LOGGER.debug("insertBusinessActivityDetail =====================================>>  " + hm);
    				staffBusinessActivityMapper.insertAppvDetails(hm);
    			}
    		}
    		LOGGER.info("추가 : {}", gridData.toString());

		}
		else
		{
			LOGGER.debug("insertBusinessActivityDetail =====================================>>  " + params);
			staffBusinessActivityMapper.insertAppvDetails(params);
		}

//    	staffBusinessActivityMapper.insertAppvDetails(params);
    }

    @Override
    public int updateAdvRequest(Map<String, Object> params) {
    	return staffBusinessActivityMapper.updateAdvRequest(params);
    }

    @Override
    public int updateAdvanceReqInfo(Map<String, Object> params) {
    	int rtn = staffBusinessActivityMapper.updateAdvanceReqInfo(params);
    	return rtn;
    }

    @Override
    public List<EgovMap> selectAdvanceList(Map<String, Object> params) {
        return staffBusinessActivityMapper.selectAdvanceList(params);
    }

    @Override
    public EgovMap getRefDtls(Map<String, Object> params) {
        return staffBusinessActivityMapper.getRefDtls(params);
    }

    @Override
    public EgovMap getAdvType(Map<String, Object> params) {
        return staffBusinessActivityMapper.getAdvType(params);
    }

    @Override
    public List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params) {
        return staffBusinessActivityMapper.selectAppvInfoAndItems(params);
    }

    @Override
    public void insertRefund(Map<String, Object> params) {
    	staffBusinessActivityMapper.insertRefund(params);
    }

    @Override
    public void insertNotification(Map<String, Object> params) {
        webInvoiceMapper.insertNotification(params);
    }

    @Override
	public String selectNextReqNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
    	LOGGER.debug("selectNextReqNo =====================================>>  " + params);
		return staffBusinessActivityMapper.selectNextReqNo(params);
	}

    @Override
    public void editRejected(Map<String, Object> params) {
        // TODO Auto-generated method stub

        LOGGER.debug("editRejected =====================================>>  " + params);

        EgovMap attachmentDetails = new EgovMap();
        attachmentDetails = (EgovMap) staffBusinessActivityMapper.getAttachmenDetails(params);
        params.put("exFileAtchGrpId", attachmentDetails.get("atchFileGrpId"));
        params.put("exFileAtchId", attachmentDetails.get("atchFileId"));

        // Duplicate File ID
        int newFileAtchGrpId = staffBusinessActivityMapper.getFileAtchGrpId();
        int newFileAtchId = staffBusinessActivityMapper.getFileAtchId();
        params.put("newFileAtchGrpId", newFileAtchGrpId);
        params.put("newFileAtchId", newFileAtchId);

        // Insert SYS0070M
        staffBusinessActivityMapper.insertSYS0070M_ER(params);

        staffBusinessActivityMapper.insertSYS0071D_ER(params);

        // Insert FCM0027M
        staffBusinessActivityMapper.insertRejectM(params);
        // Insert FCM0028D
        staffBusinessActivityMapper.insertRejectD(params);
    }

    @Override
    public String checkRefdDate(Map<String, Object> params) {
        LOGGER.debug("========== checkRefdDate ==========");
        LOGGER.debug("param :: {}", params);

        // params :: dd, mm, yyyy

        int dayAdd = 0;
        boolean flg = true;

        // Check passed date is holiday
        List<EgovMap> holidayList = staffBusinessActivityMapper.holiday_SYS81(params);

        // Set Default values
        String strDate = params.get("yyyy").toString() + params.get("mm").toString() + params.get("dd").toString();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Calendar cal = Calendar.getInstance();
        try {
            cal.setTime(sdf.parse(strDate));
        } catch (ParseException e) {
            LOGGER.error(e.toString());
            e.printStackTrace();
        }

        while(flg) {
            // Initial date will not trigger to add, only subsequent
            if(dayAdd > 0) {
                cal.add(Calendar.DATE, 1);
            }

            // Get Day of week
            int day = cal.get(Calendar.DAY_OF_WEEK);

            String nDate = sdf.format(cal.getTime());
            int holidayInt = 0;
            for(int i = 0; i < holidayList.size(); i++) {
                EgovMap map = holidayList.get(i);
                String holiday = map.get("holiday").toString();

                if(holiday.equals(nDate)) {
                    holidayInt++;
                    break;
                }
            }

            // Is holiday or weekend
            if(holidayInt > 0 || (day == Calendar.SATURDAY || day == Calendar.SUNDAY)) {
                dayAdd += 1;

            } else if(holidayInt == 0 && (day != Calendar.SATURDAY || day != Calendar.SUNDAY)) {
                flg = false;
            }
        }

        String rtn;
        if(dayAdd > 0) {
            rtn = sdf.format(cal.getTime());
        } else {
            rtn = strDate;
        }

        return rtn;
    }

    @Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return staffBusinessActivityMapper.selectAttachList(atchFileGrpId);
	}

    @Override
    public int manualStaffBusinessAdvReqSettlement(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== staffBusinessActivity.manualStaffBusinessAdvReqSettlement ==========");
        LOGGER.debug("staffBusinessActivity.manualStaffBusinessAdvReqSettlement :: params >>>>> ", params);

        params.put("userId", sessionVO.getUserId());

        int rtn = staffBusinessActivityMapper.manualStaffBusinessAdvReqSettlement(params);

        return rtn;
    }

    @Override
    public int submitAdvReq(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== staffBusinessActivity.submitAdvReq ==========");
        LOGGER.debug("staffBusinessActivity.submitAdvReq :: params >>>>> ", params);

        if(params.containsKey("refClmNo")) {
            params.put("clmNo", params.get("refClmNo"));
            params.put("appvPrcssDesc", params.get("trvRepayRem"));
        }

        String appvPrcssNo = webInvoiceMapper.selectNextAppvPrcssNo();
        params.put("appvPrcssNo", appvPrcssNo);

        List<Object> apprGridList = (List<Object>) params.get("apprLineGrid");
        params.put("appvLineCnt", apprGridList.size());

        // Insert FCM0004M
        webInvoiceMapper.insertApproveManagement(params);
        LOGGER.debug("businessActivityAdvance :: insertApproveManagement");

        if(apprGridList.size() > 0) {
            Map hm = null;
            List<String> appvLineUserId = new ArrayList<>();

            for(Object map : apprGridList) {
                hm = (HashMap<String, Object>) map;
                hm.put("appvPrcssNo", params.get("appvPrcssNo"));
                hm.put("userId", params.get("userId"));
                hm.put("userName", params.get("userName"));
                webInvoiceMapper.insertApproveLineDetail(hm);
            }

            if(params.containsKey("clmNo")) {
                params.put("clmType", params.get("clmNo").toString().substring(0, 2));
            } else if(params.containsKey("refClmNo")) {
                params.put("clmType", params.get("refClmNo").toString().substring(0, 2));
                params.put("clmNo", params.get("refClmNo"));
            }

            // Insert missed out final designated approver
            EgovMap e1 = webInvoiceMapper.getFinApprover(params);
            String memCode = e1.get("apprMemCode").toString();
            memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
            if(!appvLineUserId.contains(memCode)) {
                Map mAppr = new HashMap<String, Object>();
                mAppr.put("appvPrcssNo", params.get("appvPrcssNo"));
                mAppr.put("userId", params.get("userId"));
                mAppr.put("memCode", memCode);
                webInvoiceMapper.insMissAppr(mAppr);
            }

            Map ntf = (HashMap<String, Object>) apprGridList.get(0);
            if(params.containsKey("clmNo")) {
                ntf.put("clmNo", params.get("clmNo"));
            } else if(params.containsKey("refClmNo")) {
                ntf.put("clmNo", params.get("refClmNo"));
            }

            EgovMap ntfDtls = new EgovMap();
            ntfDtls = (EgovMap) webInvoiceMapper.getClmDesc(params);
            ntf.put("codeName", ntfDtls.get("codeDesc"));

            ntfDtls = (EgovMap) webInvoiceMapper.getNtfUser(ntf);
            ntf.put("reqstUserId", ntfDtls.get("userName"));
            ntf.put("code", params.get("clmNo").toString().substring(0, 2));
            ntf.put("appvStus", "R");
            ntf.put("rejctResn", "Pending Approval.");
            ntf.put("userId", sessionVO.getUserId());

            LOGGER.debug("ntf =====================================>>  " + ntf);

            webInvoiceMapper.insertNotification(ntf);
        }

        LOGGER.debug("businessActivityAdvance :: insert approval details");
        // Insert Approval Details
        Map hm = new HashMap<String, Object>();
        params.put("appvPrcssNo", appvPrcssNo);
        String advType = "";
        if(params.containsKey("reqAdvType")) {
            advType = (String) params.get("reqAdvType");
        } else if(params.containsKey("refAdvType_h")) {
            advType = (String) params.get("refAdvType_h");
        }

        params.put("advType", advType);
        if("1".equals(advType) || "3".equals(advType)) {
            params.put("appvItmSeq", "1");
            params.put("memAccId", params.get("payeeCode"));
            params.put("payDueDt", params.get("refdDate"));
            params.put("expType", params.get("reqAdvType"));
            if("3".equals(advType)) {
            	params.put("expTypeNm", "Staff Business Activity Expenses");
            	params.put("glAccNo", "1240300"); //12400200
            	params.put("glAccNm", "Advances-Staff Travel Expenses");
            	params.put("billPeriodFr", params.get("trvPeriodFr"));
            	params.put("billPeriodTo", params.get("trvPeriodTo"));
            	params.put("clamUn", params.get("clamUn"));
            	params.put("budgetCode", params.get("budgetCode"));
            	params.put("budgetCodeName", params.get("budgetCodeName"));
            }
            params.put("costCenter", params.get("costCenterCode"));
            params.put("costCenterNm", params.get("costCenterName"));
            params.put("amt", params.get("reqTotAmt"));
            params.put("expDesc", params.get("busActReqRem"));
            params.put("atchFileGrpId", params.get("atchFileGrpId"));
            params.put("userId", sessionVO.getUserId());
            params.put("advCurr", "MYR");

            insertAppvDetails(params);
            LOGGER.debug("businessActivityAdvance :: insertAppvDetails");

        } else if("2".equals(advType) || "4".equals(advType)) {

        	params.put("appvItmSeq", "1");
        	params.put("memAccId", params.get("refPayeeCode"));
        	params.put("invcNo", params.get("trvBankRefNo"));
        	params.put("invcDt", params.get("refAdvRepayDate"));
        	params.put("expType", params.get("refAdvType"));
            if("4".equals(advType)) {
            	params.put("expTypeNm", "Staff Business Activity Expenses Repayment");
            	params.put("glAccNo", "12400200");
            	params.put("glAccNm", "ADVANCES - STAFF (COMPANY EVENTS)");
            	params.put("budgetCode", params.get("budgetCode"));
            	params.put("budgetCodeName", params.get("budgetCodeName"));
            }
            params.put("costCenter", params.get("refCostCenterCode"));
            params.put("amt", params.get("refTotExp"));
            params.put("expDesc", params.get("trvRepayRem"));
            params.put("atchFileGrpId", params.get("refAtchFileGrpId"));
            params.put("userId", sessionVO.getUserId());

            insertAppvDetails(params);
            LOGGER.debug("businessActivityAdvance :: insertAppvDetails");
        }

        int rtn = staffBusinessActivityMapper.updateAdvanceReqInfo(params);

        return rtn;
    }

    public int saveAdvReq(Map<String, Object> params, SessionVO sessionVO)
    {
    	 LOGGER.debug("========== staffBusinessActivity.saveAdvReq ==========");
         LOGGER.debug("staffBusinessActivity.saveAdvReq :: params >>>>> ", params);

         String pClmNo = params.get("clmNo").toString();
         int rtn = 0;

     	if(pClmNo.isEmpty()) {
     		String clmType = "";
     		String glAccNo = "";
     		int clmSeq = 1;

     		if("1".equals(params.get("reqAdvType")) || "3".equals(params.get("reqAdvType"))) {
     			clmType = "REQ";
     			if("1".equals(params.get("reqAdvType"))) {
     				glAccNo = "1240300";
     			} else {
     				glAccNo = "12400200";
     			}
     		} else if("2".equals(params.get("reqAdvType")) || "4".equals(params.get("reqAdvType"))) {
     			clmType = "REF";
     			glAccNo = "22200400";
     		}

     		params.put("clmType", clmType);
     		params.put("glAccNo", glAccNo);
     		params.put("expType", params.get("advOcc"));

     		String clmNo = staffBusinessActivityMapper.selectNextClmNo(params);
     		params.put("clmNo", clmNo);
     		params.put("userId", sessionVO.getUserId());

     		rtn = staffBusinessActivityMapper.insertRequest(params);

     		Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
     		hmTrv.put("clmNo", clmNo);

     		if("3".equals(params.get("reqAdvType"))) {
     			// Staff/Company Event Advance Request
     			if(Double.parseDouble(params.get("reqTotAmt").toString()) != 0.00) {
     				hmTrv.put("advType", params.get("reqAdvType"));
     				hmTrv.put("clmSeq", clmSeq);
     				hmTrv.put("expType", params.get("advOcc"));
     				hmTrv.put("expTypeNm", params.get("advOccDesc"));
     				hmTrv.put("dAmt", params.get("reqTotAmt"));
     				hmTrv.put("userId", sessionVO.getUserId());
     				hmTrv.put("glAccNo", glAccNo);
     				hmTrv.put("cur", "MYR");
     				insertTrvDetail(hmTrv);
     				clmSeq++;
     			}
     		}

     	} else {
     		params.put("advType", params.get("reqAdvType"));
     		staffBusinessActivityMapper.editDraftRequestM(params);

     		Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
     		hmTrv.put("clmNo", params.get("clmNo"));

     		if("3".equals(params.get("reqAdvType"))) {

     			hmTrv.put("advType", params.get("reqAdvType"));

     			//Business Activity Request
     			if(amountFormatRemover(params.get("reqTotAmt").toString()) != 0) {
     				hmTrv.put("expType", params.get("advOcc"));
     				hmTrv.put("expTypeNm", params.get("advOccDesc"));
     				hmTrv.put("dAmt",params.get("reqTotAmt"));
     				hmTrv.put("userId", sessionVO.getUserId());
     				editDraftRequestD(hmTrv);
     			}

     			rtn = staffBusinessActivityMapper.updateTotal(hmTrv);
     		}
     	}

     	return rtn;
    }

    public int amountFormatRemover(String oriAmount)
    {
    	int formattedAmount = 0;

    	oriAmount =oriAmount.replace(",", "");
    	oriAmount = oriAmount.replace(".00", "");

    	formattedAmount = Integer.parseInt(oriAmount);
    	return formattedAmount;
    }

    public int saveAdvRef(Map<String, Object> params, SessionVO sessionVO){
    	int clmSeq = 1;
    	int rtn = 0;

        params.put("clmType", "REF");
        params.put("glAccNo", "22200400");
        if(params.get("refAdvType_h") != "")
        {
        	params.put("refAdvType", params.get("refAdvType_h"));
        }

        if(params.get("refAdvType_h") != "" && params.get("refAdvType_h").equals("4"))
        {
        	if(params.get("refSubmitFlg") != null && params.get("refSubmitFlg").equals("1") && params.get("refClmNo") != null)
        		params.put("clmNo", params.get("refClmNo"));
        }

        String pClmNo = params.containsKey("clmNo") ? params.get("clmNo").toString() : "";

        if(pClmNo.isEmpty()) { // Refund New Save

            String clmNo = staffBusinessActivityMapper.selectNextClmNo(params);
            params.put("clmNo", clmNo);
            params.put("userId", sessionVO.getUserId());

            // Insert FCM0027M
            //staffBusinessActivityService.insertRefund(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", clmNo);

            if("3".equals(params.get("refAdvType"))) {
                // Advance Refund for Staff Travelling Advance
                hmTrv.put("clmSeq", clmSeq);
                hmTrv.put("invcNo", params.get("trvBankRefNo"));
                hmTrv.put("invcDt", params.get("trvAdvRepayDate"));
                hmTrv.put("expType", "AD101");
                hmTrv.put("expTypeNm", "Refund Travel Advance");
                hmTrv.put("dAmt", params.get("trvAdvRepayAmt"));
                hmTrv.put("advType", params.get("reqAdvType"));
                hmTrv.put("userId", sessionVO.getUserId());
                insertTrvDetail(params);

            } else if("4".equals(params.get("refAdvType"))) {
            	// Staff/Company Event Advance Request
            	hmTrv.put("clmSeq", clmSeq);
                hmTrv.put("invcNo", params.get("refBankRef"));
                hmTrv.put("invcDt", params.get("refAdvRepayDate")); //CELESTE: grab from refund details TODO change
                hmTrv.put("expType", params.get("expType"));
                hmTrv.put("expTypeNm", params.get("expTypeNm"));
                hmTrv.put("dAmt", params.get("refTotExp"));
                hmTrv.put("userId", sessionVO.getUserId());
                params.put("advType", params.get("refAdvType_h"));
                params.put("hmTrv", hmTrv);
                params.put("refAdvRepayDate", params.get("refAdvRepayDate"));
                params.put("dAmt", params.get("refTotExp"));
                // Details
                LOGGER.debug("params ==============================>> " + params);
                insertTrvDetail(params);
            }
        } else { //Refund draft update
        	params.put("clmNo", pClmNo);
        	params.put("advType", params.get("refAdvType_h"));
        	params.put("costCenterCode", params.get("refCostCenterCode"));
        	params.put("payeeCode", params.get("refPayeeCode"));
        	params.put("bankAccNo", params.get("refBankAccNo"));
        	params.put("busActReqRem", params.get("trvRepayRem"));
        	params.put("refdDate", params.get("refAdvRepayDate"));
        	params.put("refBankRef", params.get("refBankRef"));
        	params.put("bankId", params.get("bankId"));
        	params.put("totAmt", params.get("refTotExp"));
        	staffBusinessActivityMapper.editDraftRequestM(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", params.get("refClmNo"));

            if("4".equals(params.get("refAdvType"))) {
                // Advance Refund for Staff Travelling Advance
//            	params.put("invcNo", params.get("invcNo"));
//            	params.put("invcDt", params.get("invcDt"));
            	params.put("expType", params.get("expType"));
            	params.put("expTypeNm", params.get("expTypeNm"));
            	params.put("dAmt", params.get("refTotExp"));
            	params.put("userId", sessionVO.getUserId());
            	params.put("advType", params.get("refAdvType_h"));
            	LOGGER.debug("params ==============================>> " + params);
            	editDraftRequestD(params);

            }

        }

        rtn = staffBusinessActivityMapper.updateAdvRequest(params);

        return rtn;

    }

    @Override
	public List<EgovMap> selectBank() {
		// TODO Auto-generated method stub
		return staffBusinessActivityMapper.selectBank();
	}
}
