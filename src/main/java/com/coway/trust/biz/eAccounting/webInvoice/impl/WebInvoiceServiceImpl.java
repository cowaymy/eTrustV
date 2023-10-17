package com.coway.trust.biz.eAccounting.webInvoice.impl;

import static com.coway.trust.AppConstants.EMAIL_SUBJECT;
import static com.coway.trust.AppConstants.EMAIL_TEXT;
import static com.coway.trust.AppConstants.EMAIL_TO;
import static com.coway.trust.AppConstants.REPORT_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_VIEW_TYPE;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
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
import com.coway.trust.biz.eAccounting.vendor.VendorMapper;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.eAccounting.staffBusinessActivity.impl.staffBusinessActivityMapper;
import com.coway.trust.biz.eAccounting.vendorAdvance.impl.VendorAdvanceMapper;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("webInvoiceService")
public class WebInvoiceServiceImpl implements WebInvoiceService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "webInvoiceMapper")
	private WebInvoiceMapper webInvoiceMapper;

	@Resource(name = "vendorMapper")
    private VendorMapper vendorMapper;

	@Resource(name = "staffBusinessActivityMapper")
	private staffBusinessActivityMapper staffBusinessActivityMapper;

	@Resource(name = "VendorAdvanceMapper")
	private VendorAdvanceMapper VendorAdvanceMapper;

	@Autowired
	private AdaptorService adaptorService;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectWebInvoiceList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceList(params);
	}

	@Override
	public EgovMap selectWebInvoiceInfo(String clmNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceInfo(clmNo);
	}

	@Override
	public EgovMap selectWebInvoiceInfoForAppv(String clmNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceInfoForAppv(clmNo);
	}

	@Override
	public List<EgovMap> selectWebInvoiceItems(String clmNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceItems(clmNo);
	}

	@Override
	public List<EgovMap> selectWebInvoiceItemsForAppv(String clmNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceItemsForAppv(clmNo);
	}

	@Override
	public List<EgovMap> selectApproveList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectApproveList(params);
	}

	@Override
	public List<EgovMap> selectVendorApproveList(Map<String, Object> params) {
	    return webInvoiceMapper.selectVendorApproveList(params);
	}

	@Override
	public List<EgovMap> selectAppvLineInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAppvLineInfo(params);
	}

	@Override
	public List<EgovMap> selectAppvInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAppvInfo(params);
	}

	@Override
	public String selectRejectOfAppvPrcssNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectRejectOfAppvPrcssNo(params);
	}

	@Override
	public List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAppvInfoAndItems(params);
	}

	@Override
	public List<EgovMap> selectAttachListOfAppvPrcssNo(String appvPrcssNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAttachListOfAppvPrcssNo(appvPrcssNo);
	}

	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAttachList(atchFileGrpId);
	}

	@Override
	public EgovMap selectAttachmentInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAttachmentInfo(params);
	}

	@Override
	public void insertWebInvoiceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub

		LOGGER.debug("insertWebInvoiceInfo =====================================>>  " + params);

		webInvoiceMapper.insertWebInvoiceInfo(params);

		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

		List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기

		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", (String) params.get("clmNo"));
				int clmSeq = webInvoiceMapper.selectNextClmSeq((String) params.get("clmNo"));
				hm.put("clmSeq", clmSeq);
				hm.put("clmType", "J1");
				hm.put("userId", params.get("userId"));
				LOGGER.debug("insertWebInvoiceDetail =====================================>>  " + params);
				webInvoiceMapper.insertWebInvoiceDetail(hm);
			}
		}


		LOGGER.info("추가 : {}", addList.toString());
	}

	@Override
	public void updateWebInvoiceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		webInvoiceMapper.updateWebInvoiceInfo(params);

		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

		List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기
		List<Object> updateList = (List<Object>) gridData.get("update"); // 수정 리스트 얻기
		List<Object> removeList = (List<Object>) gridData.get("remove"); // 제거 리스트 얻기

		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				int clmSeq = webInvoiceMapper.selectNextClmSeq((String) params.get("clmNo"));
				hm.put("clmSeq", clmSeq);
				hm.put("clmType", "J1");
				hm.put("userId", params.get("userId"));
				LOGGER.debug("insertWebInvoiceDetail =====================================>>  " + hm);
				webInvoiceMapper.insertWebInvoiceDetail(hm);
			}
		}
		if (updateList.size() > 0) {
			Map hm = null;

			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				LOGGER.debug("updateWebInvoiceDetail =====================================>>  " + hm);
				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
				webInvoiceMapper.updateWebInvoiceDetail(hm);
			}
		}
		if (removeList.size() > 0) {
			Map hm = null;

			for (Object map : removeList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				// TODO biz처리 (clmNo, clmSeq 값으로 delete 처리)
				LOGGER.debug("deleteWebInvoiceDetail =====================================>>  " + hm);
				webInvoiceMapper.deleteWebInvoiceDetail(hm);
			}
		}

		webInvoiceMapper.updateWebInvoiceInfoTotAmt(params);

		LOGGER.info("추가 : {}", addList.toString());
		LOGGER.info("수정 : {}", updateList.toString());
		LOGGER.info("삭제 : {}", removeList.toString());
	}

	@Override
	public void insertApproveManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		List<Object> newGridList = (List<Object>) params.get("newGridList");

		params.put("appvLineCnt", apprGridList.size());

		LOGGER.debug("insertApproveManagement =====================================>>  " + params);
		webInvoiceMapper.insertApproveManagement(params);

		if (apprGridList.size() > 0) {
		    //webInvoiceMapper.getFinApprover
			Map hm = null;
			List<String> appvLineUserId = new ArrayList<>();

			for (Object map : apprGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveLineDetail =====================================>>  " + hm);
				// TODO appvLineDetailTable Insert
				webInvoiceMapper.insertApproveLineDetail(hm);

				appvLineUserId.add(hm.get("memCode").toString());
			}

			params.put("clmType", params.get("clmNo").toString().substring(0, 2));
			EgovMap e1 = webInvoiceMapper.getFinApprover(params);
			String memCode = e1.get("apprMemCode").toString();
			LOGGER.debug("getFinApprover.memCode =====================================>>  " + memCode);
	        memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
			if(!appvLineUserId.contains(memCode)) {
			    Map mAppr = new HashMap<String, Object>();
			    mAppr.put("appvPrcssNo", params.get("appvPrcssNo"));
			    mAppr.put("userId", params.get("userId"));
			    mAppr.put("memCode", memCode);
			    LOGGER.debug("insMissAppr =====================================>>  " + mAppr);
			    webInvoiceMapper.insMissAppr(mAppr);
            }

			// 2019-02-19 - LaiKW - Insert notification for request.
			Map ntf = (HashMap<String, Object>) apprGridList.get(0);
			ntf.put("clmNo", params.get("clmNo"));

			EgovMap ntfDtls = new EgovMap();
			ntfDtls = (EgovMap) webInvoiceMapper.getClmDesc(params);
			ntf.put("codeName", ntfDtls.get("codeDesc"));

			ntfDtls = (EgovMap) webInvoiceMapper.getNtfUser(ntf);
			ntf.put("reqstUserId", ntfDtls.get("userName"));
			ntf.put("code", params.get("clmNo").toString().substring(0, 2));
			ntf.put("appvStus", "R");
			ntf.put("rejctResn", "Pending Approval.");

			LOGGER.debug("ntf =====================================>>  " + ntf);

			webInvoiceMapper.insertNotification(ntf);

		}

		if (newGridList.size() > 0) {
			Map hm = null;

			// biz처리
			for (Object map : newGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				//int appvItmSeq = webInvoiceMapper.selectNextAppvItmSeq(String.valueOf(params.get("appvPrcssNo")));
				//hm.put("appvItmSeq", appvItmSeq);
				hm.put("invcNo", params.get("invcNo"));
				hm.put("invcDt", params.get("invcDt"));
				hm.put("invcType", params.get("invcType"));
				hm.put("memAccId", params.get("memAccId"));
				hm.put("payDueDt", params.get("payDueDt"));
				hm.put("costCentr", params.get("costCentr"));
				hm.put("costCentrName", params.get("costCentrName"));
				hm.put("atchFileGrpId", params.get("atchFileGrpId"));
				hm.put("utilNo", params.get("utilNo"));
				hm.put("jPayNo", params.get("jPayNo"));
				hm.put("bilPeriodF", params.get("bilPeriodF"));
				hm.put("bilPeriodT", params.get("bilPeriodT"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveItems =====================================>>  " + hm);
				// TODO appvLineItemsTable Insert
				webInvoiceMapper.insertApproveItems(hm);
			}
		}

		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		webInvoiceMapper.updateAppvPrcssNo(params);
	}

	@Override
	public void updateApprovalInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		List<Object> invoAppvGridList = (List<Object>) params.get("invoAppvGridList");
		String rejctResn = (String) params.get("rejctResn");

		List<Map<String, Object>> emailDetailList = new ArrayList<Map<String,Object>>();
		for (int i = 0; i < invoAppvGridList.size(); i++) {
			Map<String, Object> invoAppvInfo = (Map<String, Object>) invoAppvGridList.get(i);
			String appvPrcssNo = (String) invoAppvInfo.get("appvPrcssNo");
			int appvLineSeq = (int) invoAppvInfo.get("appvLineSeq");
			int appvLineCnt = webInvoiceMapper.selectAppvLineCnt(appvPrcssNo);
			int appvLinePrcssCnt = webInvoiceMapper.selectAppvLinePrcssCnt(appvPrcssNo);
			invoAppvInfo.put("appvLinePrcssCnt", appvLinePrcssCnt + 1);
			invoAppvInfo.put("appvPrcssStus", "P");
			invoAppvInfo.put("appvStus", "A");
			invoAppvInfo.put("rejctResn", rejctResn);
			invoAppvInfo.put("userId", params.get("userId"));
			LOGGER.debug("now invoAppvInfo =====================================>>  " + invoAppvInfo);
			webInvoiceMapper.updateAppvInfo(invoAppvInfo);
			webInvoiceMapper.updateAppvLine(invoAppvInfo);
			// TODO 다음 승인자 R처리
			if(appvLineCnt > appvLineSeq) {
				invoAppvInfo.put("appvStus", "R");
				invoAppvInfo.put("appvLineSeq", appvLineSeq + 1);
				invoAppvInfo.put("rejctResn", "");
				LOGGER.debug("next invoAppvInfo =====================================>>  " + invoAppvInfo);
				webInvoiceMapper.updateAppvLine(invoAppvInfo);

				Map ntf = new HashMap<String, Object>();
	            ntf.put("clmNo", invoAppvInfo.get("clmNo"));

				EgovMap ntfDtls = (EgovMap) webInvoiceMapper.getClmDesc(invoAppvInfo);
				ntf.put("codeName", ntfDtls.get("codeDesc"));

				ntfDtls = (EgovMap) webInvoiceMapper.getNtfUser(invoAppvInfo);
				ntf.put("reqstUserId", ntfDtls.get("userName"));
				ntf.put("code", invoAppvInfo.get("clmNo").toString().substring(0, 2));
				ntf.put("appvStus", "R");
	            ntf.put("rejctResn", "Pending Approval.");

	            LOGGER.debug("ntf =====================================>>  " + ntf);

	            webInvoiceMapper.insertNotification(ntf);
			}
			if(appvLineCnt == appvLinePrcssCnt + 1) {
				LOGGER.debug("last invoAppvInfo =====================================>>  " + invoAppvInfo);
				// 마지막 승인인 경우 재업데이트
				webInvoiceMapper.updateLastAppvLine(invoAppvInfo);
				// TODO 인터페이스 생성
				// interface 생성
				String clmNo = String.valueOf(invoAppvInfo.get("clmNo"));
				String clmType = clmNo.substring(0, 2);
				LOGGER.debug("clmType =====================================>>  " + clmType);
				invoAppvInfo.put("clmType", clmType); // 2018-10-29 - LaiKW - Added clmType key value for Credit Card SQL
				if("J1".equals(clmType) || "J2".equals(clmType) || "J3".equals(clmType) || "J4".equals(clmType) || "J5".equals(clmType) || "J6".equals(clmType) || "J7".equals(clmType) || "J8".equals(clmType) || "J9".equals(clmType)) {
					// appvPrcssNo의 items get
					List<EgovMap> appvInfoAndItems = webInvoiceMapper.selectAppvInfoAndItems(invoAppvInfo);
					for(int j = 0; j < appvInfoAndItems.size(); j++) {
						String ifKey = webInvoiceMapper.selectNextAppvIfKey();
						Map<String, Object> invoAppvItems = (Map<String, Object>) appvInfoAndItems.get(j);
						invoAppvItems.put("ifKey", ifKey);
						invoAppvItems.put("userId", params.get("userId"));
						LOGGER.debug("insertAppvInterface =====================================>>  " + invoAppvItems);
						webInvoiceMapper.insertAppvInterface(invoAppvItems);
					}
					//Send Email Here for Staff claim which reach last approval line
					Map<String, Object> emailDetail = new HashMap<String,Object>();
					emailDetail.put("clmNo",invoAppvInfo.get("clmNo").toString());
					emailDetail.put("reqstUserId",invoAppvInfo.get("reqstUserId").toString());
					emailDetail.put("reqstDt",invoAppvInfo.get("reqstDt").toString());
					EgovMap userDetail = webInvoiceMapper.selectUserDetail(emailDetail);
					emailDetail.put("appvPrcssStus", "A");
					emailDetail.put("email",userDetail.get("userEmail").toString());
					emailDetailList.add(emailDetail);
				} else if("R1".equals(clmType)) {
					// appvPrcssNo의 items get
					List<EgovMap> appvInfoAndItems = webInvoiceMapper.selectAppvInfoAndItems(invoAppvInfo);
					for(int j = 0; j < appvInfoAndItems.size(); j++) {
						String ifKey = webInvoiceMapper.selectNextReqstIfKey();
						Map<String, Object> invoAppvItems = (Map<String, Object>) appvInfoAndItems.get(j);
						invoAppvItems.put("ifKey", ifKey);
						invoAppvItems.put("userId", params.get("userId"));
						LOGGER.debug("insertReqstInterface =====================================>>  " + invoAppvItems);
						webInvoiceMapper.insertReqstInterface(invoAppvItems);
					}
				} else if("R2".equals(clmType) || "A1".equals(clmType)) {
				    List<EgovMap> appvInfoAndItems = webInvoiceMapper.selectAdvInfoAndItems(invoAppvInfo);
				    for(int j = 0; j < appvInfoAndItems.size(); j++) {
                        String ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
                        Map<String, Object> invoAppvItems = (Map<String, Object>) appvInfoAndItems.get(j);
                        invoAppvItems.put("ifKey", ifKey);
                        invoAppvItems.put("userId", params.get("userId"));

                        if("1".equals(invoAppvItems.get("advType").toString()) || "2".equals(invoAppvItems.get("advType").toString())) {
                            invoAppvItems.put("grandAmt", invoAppvItems.get("netAmt"));
                            invoAppvItems.put("expAmt", 0);
                            invoAppvItems.put("balAmt", 0);
                            invoAppvItems.put("taxAmt", 0);
                            invoAppvItems.put("nonTaxAmt", 0);
                            invoAppvItems.put("taxCode", "");

                            if("1".equals(invoAppvItems.get("advType").toString())) {
                                invoAppvItems.put("docDt", invoAppvItems.get("reqstDt"));
                                invoAppvItems.put("dueDt", invoAppvItems.get("appvPrcssDt")); // Celeste : Ticket : 23021352 : Change to approval date instead of request date
                            }

                            if("2".equals(invoAppvItems.get("advType").toString())) {
                                invoAppvItems.put("docDt", invoAppvItems.get("invcDt"));
                                invoAppvItems.put("dueDt", invoAppvItems.get("appvPrcssDt"));
                                invoAppvItems.put("glCode", "0012510100");
                            }
                        }

                        LOGGER.debug("insertAppvInterface =====================================>>  " + invoAppvItems);

                        webInvoiceMapper.insertAdvInterface(invoAppvItems);
                    }
				} else if("V1".equals(clmType)) {
				    LOGGER.debug("insertVendorInterface :: ", invoAppvInfo);
				    vendorMapper.insertVendorInterface(invoAppvInfo);
				}
				else if("R3".equals(clmType) || "A2".equals(clmType))
				{
					List<EgovMap> appvInfoAndItems = staffBusinessActivityMapper.selectAdvInfoAndItems(invoAppvInfo); //itemize record
					Map<String, Object> appvSettlementInfo = null;
					Map<String, Object> refundRecordInfo = null;
					String docDate = null;

					BigDecimal diffAmt = BigDecimal.ZERO; //initiate as 0, 0=no outstanding and balance
					BigDecimal reqAmt, expAmt = BigDecimal.ZERO;
					boolean diffAmtFlg = false; // false: No need to insert (request<exp)
				    for(int j = 0; j < appvInfoAndItems.size(); j++) {
                        String ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
                        Map<String, Object> invoAppvItems = (Map<String, Object>) appvInfoAndItems.get(j);
                        invoAppvItems.put("ifKey", ifKey);
                        invoAppvItems.put("userId", "");
                        invoAppvItems.put("curr", "currency");


                        if("3".equals(invoAppvItems.get("advType").toString()) || "4".equals(invoAppvItems.get("advType").toString())) {
                            invoAppvItems.put("taxAmt", 0);
                            invoAppvItems.put("nonTaxAmt", 0);
                            invoAppvItems.put("taxCode", "");

                            if("3".equals(invoAppvItems.get("advType").toString())) {
                            	invoAppvItems.put("grandAmt", invoAppvItems.get("netAmt"));
                            	invoAppvItems.put("docDt", invoAppvItems.get("reqstDt"));
                                invoAppvItems.put("dueDt", invoAppvItems.get("appvPrcssDt")); //Celeste : Ticket : 23021352 : Change to approval date instead of request date
                            }

                            if("4".equals(invoAppvItems.get("advType").toString())) {
                            	invoAppvItems.put("docDt", appvInfoAndItems.get(0).get("invcDt"));
                                docDate = (String)invoAppvItems.get("docDt");
                            	//invoAppvItems.put("expAmt", 0);
                            	invoAppvItems.put("grandAmt", 0);
                            	invoAppvItems.put("balAmt", 0);
                                //invoAppvItems.put("docDt", invoAppvItems.get("invcDt"));
                            	invoAppvItems.put("docDt", docDate);
                                invoAppvItems.put("dueDt", invoAppvItems.get("appvPrcssDt"));
                                invoAppvItems.put("totAmt", invoAppvItems.get("netAmt"));
                                invoAppvItems.put("glCode", invoAppvItems.get("glCode"));
                                invoAppvItems.put("memAccId", "");
                                invoAppvItems.put("dim1", invoAppvItems.get("dim1"));
                                invoAppvItems.put("dim2", invoAppvItems.get("bgtCode"));

                                reqAmt = (BigDecimal)invoAppvItems.get("reqAmt");
                                expAmt = expAmt.add((BigDecimal)invoAppvItems.get("expAmt"));
                                //expAmt = (BigDecimal)invoAppvItems.get("totAmt");
                                //diffAmt = reqAmt - expAmt;
                                diffAmt= reqAmt.subtract(expAmt);
                                //invoAppvItems.put("expAmt", expAmt);
                                invoAppvItems.put("expAmt", invoAppvItems.get("expAmt"));

                                if(diffAmt.compareTo(BigDecimal.ZERO) == -1) //if(diffAmt < 0)
                                {
                                	//insert settlement request with itemize total as 1 record
                                	//insert balance amt 1 line
                                	diffAmtFlg = true;
//                                	invoAppvItems.put("balAmt", diffAmt);
                                }
                            }
                        }

                        LOGGER.debug("insertAppvInterface =====================================>>  " + invoAppvItems);

                        staffBusinessActivityMapper.insertBusinessActAdvInterface(invoAppvItems);
                    }
				    String ifKey;
				    if(diffAmt.compareTo(BigDecimal.ZERO) == -1)  //if(diffAmt < 0) //expenses more than advance
				    {
				    	//itemize total as 1 record
				    	appvSettlementInfo = staffBusinessActivityMapper.selectSettlementInfo(invoAppvInfo); //main record
				    	ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
				    	appvSettlementInfo.put("ifKey", ifKey);
				    	appvSettlementInfo.put("userId", params.get("userId"));
				    	appvSettlementInfo.put("glCode", "12400200");
				    	appvSettlementInfo.put("grandAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("totAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("expAmt", "0");
				    	appvSettlementInfo.put("balAmt", "0");
				    	appvSettlementInfo.put("taxAmt", "0");
				    	appvSettlementInfo.put("nonTaxAmt", "0");
				    	appvSettlementInfo.put("docDt", docDate);
				    	appvSettlementInfo.put("dueDt", appvSettlementInfo.get("appvPrcssDt"));
				    	appvSettlementInfo.put("curr", appvSettlementInfo.get("currency"));
				    	staffBusinessActivityMapper.insertBusinessActAdvInterface(appvSettlementInfo);
//
				    	// insert balance amount as 1 record
				    	invoAppvInfo.put("flg", "0");
				    	refundRecordInfo = staffBusinessActivityMapper.selectBalanceInfo(invoAppvInfo); //balance refund record
				    	ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
				    	refundRecordInfo.put("ifKey", ifKey);
				    	refundRecordInfo.put("userId", params.get("userId"));
				    	refundRecordInfo.put("totAmt", refundRecordInfo.get("balAmt"));
				    	refundRecordInfo.put("balAmt", refundRecordInfo.get("balAmt"));
				    	refundRecordInfo.put("grandAmt", 0);
				    	refundRecordInfo.put("expAmt", "0");
				    	refundRecordInfo.put("taxAmt", "0");
				    	refundRecordInfo.put("nonTaxAmt", "0");
				    	refundRecordInfo.put("glCode", "22200400");
				    	refundRecordInfo.put("docDt", docDate);
				    	refundRecordInfo.put("dueDt", refundRecordInfo.get("appvPrcssDt"));
				    	refundRecordInfo.put("curr", refundRecordInfo.get("currency"));
				    	staffBusinessActivityMapper.insertBusinessActAdvInterface(refundRecordInfo);

				    	LOGGER.debug("appvSettlementInfo =====================================>>  " + appvSettlementInfo);
                        LOGGER.debug("refundRecordInfo =====================================>>  " + refundRecordInfo);
				    }
				    else if(diffAmt.compareTo(BigDecimal.ZERO) == 1)//else if(diffAmt > 0) //advance more than expenses
				    {

				    	//itemize total as 1 record
				    	appvSettlementInfo = staffBusinessActivityMapper.selectSettlementInfo(invoAppvInfo); //main record
				    	ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
				    	appvSettlementInfo.put("ifKey", ifKey);
				    	appvSettlementInfo.put("userId", params.get("userId"));
				    	appvSettlementInfo.put("grandAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("glCode", "12400200");
				    	appvSettlementInfo.put("totAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("expAmt", "0");
				    	appvSettlementInfo.put("balAmt", "0");
				    	appvSettlementInfo.put("taxAmt", "0");
				    	appvSettlementInfo.put("nonTaxAmt", "0");
				    	appvSettlementInfo.put("docDt", docDate);
				    	appvSettlementInfo.put("dueDt", appvSettlementInfo.get("appvPrcssDt"));
				    	appvSettlementInfo.put("curr", appvSettlementInfo.get("currency"));
				    	staffBusinessActivityMapper.insertBusinessActAdvInterface(appvSettlementInfo);

				    	// insert balance amount as 1 record
				    	invoAppvInfo.put("flg", "1");
				    	refundRecordInfo = staffBusinessActivityMapper.selectBalanceInfo(invoAppvInfo); //balance refund record
				    	ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
				    	refundRecordInfo.put("ifKey", ifKey);
				    	refundRecordInfo.put("userId", params.get("userId"));
				    	refundRecordInfo.put("totAmt", refundRecordInfo.get("balAmt"));
				    	refundRecordInfo.put("glCode", "22200400");
//				    	refundRecordInfo.put("memAccId", "");
//				    	refundRecordInfo.put("grandAmt", refundRecordInfo.get("balAmt"));
				    	refundRecordInfo.put("grandAmt", 0);
				    	refundRecordInfo.put("docDt", docDate);
				    	refundRecordInfo.put("dueDt", refundRecordInfo.get("appvPrcssDt"));
				    	refundRecordInfo.put("expAmt", refundRecordInfo.get("balAmt"));
				    	refundRecordInfo.put("balAmt", "0");
				    	refundRecordInfo.put("taxAmt", "0");
				    	refundRecordInfo.put("nonTaxAmt", "0");
				    	refundRecordInfo.put("curr", refundRecordInfo.get("currency"));
				    	staffBusinessActivityMapper.insertBusinessActAdvInterface(refundRecordInfo);

				    	LOGGER.debug("appvSettlementInfo =====================================>>  " + appvSettlementInfo);
                        LOGGER.debug("refundRecordInfo =====================================>>  " + refundRecordInfo);
				    }
				    else if(diffAmt.compareTo(BigDecimal.ZERO) == 0 && "A2".equals(clmType)) //advance == expenses (exclude balance record)
				    {

				    	//itemize total as 1 record
				    	appvSettlementInfo = staffBusinessActivityMapper.selectSettlementInfo(invoAppvInfo); //main record
				    	ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
				    	appvSettlementInfo.put("ifKey", ifKey);
				    	appvSettlementInfo.put("userId", params.get("userId"));
				    	appvSettlementInfo.put("grandAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("glCode", "12400200");
				    	appvSettlementInfo.put("totAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("expAmt", "0");
				    	appvSettlementInfo.put("balAmt", "0");
				    	appvSettlementInfo.put("taxAmt", "0");
				    	appvSettlementInfo.put("nonTaxAmt", "0");
				    	appvSettlementInfo.put("docDt", docDate);
				    	appvSettlementInfo.put("dueDt", appvSettlementInfo.get("appvPrcssDt"));
				    	appvSettlementInfo.put("curr", appvSettlementInfo.get("currency"));
				    	staffBusinessActivityMapper.insertBusinessActAdvInterface(appvSettlementInfo);

				    	LOGGER.debug("appvSettlementInfo =====================================>>  " + appvSettlementInfo);
				    }

				}
				else if("R4".equals(clmType) || "A3".equals(clmType))
				{
					//EgovMap appvInfoAndItems = VendorAdvanceMapper.selectVendorAdvanceDetails(invoAppvInfo.get("clmNo").toString());
					List<EgovMap> appvInfoAndItems = VendorAdvanceMapper.selectVendorAdvanceDetailsList(invoAppvInfo); //itemize record
					Map<String, Object> appvSettlementInfo = null;
					Map<String, Object> refundRecordInfo = null;
					String docDate = null;

					BigDecimal diffAmt = BigDecimal.ZERO; //initiate as 0, 0=no outstanding and balance
					//int diffAmt = 0; //initiate as 0, 0=no outstanding and balance
					boolean diffAmtFlg = false; // false: No need to insert (request<exp)
					BigDecimal reqAmt, expAmt = BigDecimal.ZERO;
				    for(int j = 0; j < appvInfoAndItems.size(); j++) {
                        String ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
                        Map<String, Object> invoAppvItems = (Map<String, Object>) appvInfoAndItems.get(j);
                        invoAppvItems.put("ifKey", ifKey);
                        invoAppvItems.put("userId", "");
                        invoAppvItems.put("curr", invoAppvItems.get("currency"));

                        if("5".equals(invoAppvItems.get("advType").toString()) || "6".equals(invoAppvItems.get("advType").toString())) {
                            invoAppvItems.put("taxAmt", 0);
                            invoAppvItems.put("nonTaxAmt", 0);
                            invoAppvItems.put("taxCode", "");

                            if("5".equals(invoAppvItems.get("advType").toString())) {
                            	invoAppvItems.put("grandAmt", invoAppvItems.get("totAmt"));
                                invoAppvItems.put("docDt", invoAppvItems.get("crtDt"));
                                invoAppvItems.put("dueDt", invoAppvItems.get("appvPrcssDt"));//APPV_PRCSS_DT
                                invoAppvItems.put("reqstUserId", invoAppvItems.get("userName"));
                                invoAppvItems.put("reqstDt", invoAppvItems.get("crtDt"));
                                invoAppvItems.put("costCentrName", invoAppvItems.get("costCenterNm"));

                            }

                            if("6".equals(invoAppvItems.get("advType").toString())) {
                            	invoAppvItems.put("docDt", appvInfoAndItems.get(0).get("invcDt"));
                            	docDate = (String)invoAppvItems.get("docDt");
                                //invoAppvItems.put("docDt", invoAppvItems.get("invcDt"));
                            	invoAppvItems.put("grandAmt", 0);
                                invoAppvItems.put("dueDt", invoAppvItems.get("appvPrcssDt"));
                                invoAppvItems.put("glCode", invoAppvItems.get("glAccNo"));
                                invoAppvItems.put("costCentrName", invoAppvItems.get("costCenterNm"));
                                invoAppvItems.put("memAccId", "");
                                invoAppvItems.put("totAmt", invoAppvItems.get("expAmt"));
                                invoAppvItems.put("dim1", invoAppvItems.get("costCenter"));
                                invoAppvItems.put("dim2", invoAppvItems.get("bgtCode"));

                                //BigDecimal reqAmt, expAmt = BigDecimal.ZERO;
                                reqAmt = (BigDecimal)invoAppvItems.get("reqAmt");
                                //expAmt = (BigDecimal)invoAppvItems.get("expAmt");
                                expAmt = expAmt.add((BigDecimal)invoAppvItems.get("expAmt"));
                                //diffAmt = reqAmt - expAmt;
                                diffAmt= reqAmt.subtract(expAmt);
                                invoAppvItems.put("expAmt", invoAppvItems.get("expAmt"));

                                /*int reqAmt, expAmt;
                                reqAmt = Integer.valueOf(invoAppvItems.get("grandAmt").toString());
                                expAmt = Integer.valueOf(invoAppvItems.get("expAmt").toString());
                                diffAmt = reqAmt - expAmt;
                                invoAppvItems.put("expAmt", 0);
                                invoAppvItems.put("balAmt", 0);*/
                                if(diffAmt.compareTo(BigDecimal.ZERO) == -1)
                                {
                                	//insert settlement request with itemize total as 1 record
                                	//insert balance amt 1 line
                                	diffAmtFlg = true;
                                }
                            }
                        }

                        LOGGER.debug("insertAppvInterface =====================================>>  " + invoAppvItems);

                        VendorAdvanceMapper.insertVendorAdvInterface(invoAppvItems);

				    }

				    String ifKey;
				    if(diffAmt.compareTo(BigDecimal.ZERO) == -1) //expenses more than advance
				    {
				    	//itemize total as 1 record
				    	appvSettlementInfo = VendorAdvanceMapper.selectSettlementInfo(invoAppvInfo); //main record
				    	ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
				    	appvSettlementInfo.put("ifKey", ifKey);
				    	appvSettlementInfo.put("userId", params.get("userId"));
				    	appvSettlementInfo.put("glAccNo", "12400100");
				    	/*appvSettlementInfo.put("grandAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("totAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("docDt", appvSettlementInfo.get("invcDt"));*/
				    	appvSettlementInfo.put("dueDt", appvSettlementInfo.get("appvPrcssDt"));
				    	appvSettlementInfo.put("grandAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("totAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("expAmt", "0");
				    	appvSettlementInfo.put("balAmt", "0");
				    	appvSettlementInfo.put("taxAmt", "0");
				    	appvSettlementInfo.put("nonTaxAmt", "0");
				    	appvSettlementInfo.put("docDt", docDate);
				    	appvSettlementInfo.put("curr", appvSettlementInfo.get("currency"));
				    	appvSettlementInfo.put("rem", appvSettlementInfo.get("expDesc"));
				    	VendorAdvanceMapper.insertVendorAdvInterface(appvSettlementInfo);
//
				    	// insert balance amount as 1 record
				    	invoAppvInfo.put("flg", "0");
				    	refundRecordInfo = VendorAdvanceMapper.selectBalanceInfo(invoAppvInfo); //balance refund record
				    	ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
				    	refundRecordInfo.put("ifKey", ifKey);
				    	refundRecordInfo.put("userId", params.get("userId"));
				    	/*refundRecordInfo.put("totAmt", refundRecordInfo.get("balAmt"));
				    	refundRecordInfo.put("balAmt", refundRecordInfo.get("balAmt"));*/
				    	refundRecordInfo.put("totAmt", refundRecordInfo.get("balAmt"));
				    	refundRecordInfo.put("balAmt", refundRecordInfo.get("balAmt"));
				    	refundRecordInfo.put("grandAmt", 0);
				    	refundRecordInfo.put("expAmt", "0");
				    	refundRecordInfo.put("taxAmt", "0");
				    	refundRecordInfo.put("nonTaxAmt", "0");
				    	refundRecordInfo.put("glAccNo", "22200400");
				    	refundRecordInfo.put("docDt", docDate);
				    	//refundRecordInfo.put("docDt", refundRecordInfo.get("invcDt"));
				    	refundRecordInfo.put("dueDt", refundRecordInfo.get("appvPrcssDt"));
				    	refundRecordInfo.put("curr", refundRecordInfo.get("currency"));
				    	refundRecordInfo.put("rem", refundRecordInfo.get("expDesc"));
				    	VendorAdvanceMapper.insertVendorAdvInterface(refundRecordInfo);

				    	LOGGER.debug("appvSettlementInfo =====================================>>  " + appvSettlementInfo);
                        LOGGER.debug("refundRecordInfo =====================================>>  " + refundRecordInfo);
				    }
				    else if(diffAmt.compareTo(BigDecimal.ZERO) == 1) //advance more than expenses
				    {

				    	//itemize total as 1 record
				    	appvSettlementInfo = VendorAdvanceMapper.selectSettlementInfo(invoAppvInfo); //main record
				    	ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
				    	appvSettlementInfo.put("ifKey", ifKey);
				    	appvSettlementInfo.put("userId", params.get("userId"));
				    	appvSettlementInfo.put("grandAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("glAccNo", "12400100");
				    	appvSettlementInfo.put("expAmt", "0");
				    	appvSettlementInfo.put("balAmt", "0");
				    	appvSettlementInfo.put("taxAmt", "0");
				    	appvSettlementInfo.put("nonTaxAmt", "0");
				    	appvSettlementInfo.put("docDt", docDate);
				    	appvSettlementInfo.put("totAmt", appvSettlementInfo.get("reqAmt"));
				    	//appvSettlementInfo.put("docDt", appvSettlementInfo.get("invcDt"));
				    	appvSettlementInfo.put("dueDt", appvSettlementInfo.get("appvPrcssDt"));
				    	appvSettlementInfo.put("curr", appvSettlementInfo.get("currency"));
				    	appvSettlementInfo.put("rem", appvSettlementInfo.get("expDesc"));
				    	VendorAdvanceMapper.insertVendorAdvInterface(appvSettlementInfo);

				    	// insert balance amount as 1 record
				    	invoAppvInfo.put("flg", "1");
				    	refundRecordInfo = VendorAdvanceMapper.selectBalanceInfo(invoAppvInfo); //balance refund record
				    	ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
				    	refundRecordInfo.put("ifKey", ifKey);
				    	refundRecordInfo.put("userId", params.get("userId"));
				    	refundRecordInfo.put("totAmt", refundRecordInfo.get("balAmt"));
				    	refundRecordInfo.put("glAccNo", "22200400");
				    	refundRecordInfo.put("grandAmt", 0);
				    	refundRecordInfo.put("docDt", docDate);
				    	refundRecordInfo.put("dueDt", refundRecordInfo.get("appvPrcssDt"));
				    	refundRecordInfo.put("expAmt", refundRecordInfo.get("balAmt"));
				    	refundRecordInfo.put("taxAmt", "0");
				    	refundRecordInfo.put("nonTaxAmt", "0");
				    	refundRecordInfo.put("curr", refundRecordInfo.get("currency"));
				    	refundRecordInfo.put("balAmt", "0");
				    	refundRecordInfo.put("rem", refundRecordInfo.get("expDesc"));
				    	VendorAdvanceMapper.insertVendorAdvInterface(refundRecordInfo);

				    	LOGGER.debug("appvSettlementInfo =====================================>>  " + appvSettlementInfo);
                        LOGGER.debug("refundRecordInfo =====================================>>  " + refundRecordInfo);
				    }
				    else if(diffAmt.compareTo(BigDecimal.ZERO) == 0 && "A3".equals(clmType)) //advance == expenses
				    {

				    	//itemize total as 1 record
				    	appvSettlementInfo = VendorAdvanceMapper.selectSettlementInfo(invoAppvInfo); //main record
				    	ifKey = webInvoiceMapper.selectNextAdvAppvIfKey();
				    	appvSettlementInfo.put("ifKey", ifKey);
				    	appvSettlementInfo.put("userId", params.get("userId"));
				    	appvSettlementInfo.put("grandAmt", appvSettlementInfo.get("reqAmt"));
				    	appvSettlementInfo.put("glAccNo", "12400100");
				    	appvSettlementInfo.put("expAmt", "0");
				    	appvSettlementInfo.put("balAmt", "0");
				    	appvSettlementInfo.put("taxAmt", "0");
				    	appvSettlementInfo.put("nonTaxAmt", "0");
				    	appvSettlementInfo.put("docDt", docDate);
				    	appvSettlementInfo.put("totAmt", appvSettlementInfo.get("reqAmt"));
				    	//appvSettlementInfo.put("docDt", appvSettlementInfo.get("invcDt"));
				    	appvSettlementInfo.put("dueDt", appvSettlementInfo.get("appvPrcssDt"));
				    	appvSettlementInfo.put("curr", appvSettlementInfo.get("currency"));
				    	appvSettlementInfo.put("rem", appvSettlementInfo.get("expDesc"));
				    	VendorAdvanceMapper.insertVendorAdvInterface(appvSettlementInfo);

				    	LOGGER.debug("appvSettlementInfo =====================================>>  " + appvSettlementInfo);				    }
				}
			}
		}

		if(emailDetailList.size() > 0)
		{
			this.sendEmail(emailDetailList);
		}
	}

	@Override
	public void updateRejectionInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		List<Object> invoAppvGridList = (List<Object>) params.get("invoAppvGridList");
		String rejctResn = (String) params.get("rejctResn");

		List<Map<String, Object>> emailDetailList = new ArrayList<Map<String,Object>>();
		for (int i = 0; i < invoAppvGridList.size(); i++) {
			Map<String, Object> invoAppvInfo = (Map<String, Object>) invoAppvGridList.get(i);
			String appvPrcssNo = (String) invoAppvInfo.get("appvPrcssNo");
			String vendorClmNo = (String) invoAppvInfo.get("clmNo");
			int appvLineCnt = webInvoiceMapper.selectAppvLineCnt(appvPrcssNo);
			int appvLinePrcssCnt = webInvoiceMapper.selectAppvLinePrcssCnt(appvPrcssNo);
			invoAppvInfo.put("appvLinePrcssCnt", appvLinePrcssCnt + 1);
			invoAppvInfo.put("appvPrcssStus", "J");
			invoAppvInfo.put("appvStus", "J");
			invoAppvInfo.put("rejctResn", rejctResn);
			invoAppvInfo.put("isResubmitAllowed", params.get("isResubmitAllowed"));
			invoAppvInfo.put("userId", params.get("userId"));

			LOGGER.debug("vendorClmNo =====================================>>  " + vendorClmNo);
			if(vendorClmNo.substring(0, 2).equals("V1"))
			{
				EgovMap ntfDtls = (EgovMap) webInvoiceMapper.getClmDesc(invoAppvInfo);
				String code = vendorClmNo.substring(0, 2);
				invoAppvInfo.put("code", code);
				invoAppvInfo.put("codeName", ntfDtls.get("codeDesc"));
			}
			LOGGER.debug("rejection invoAppvInfo =====================================>>  " + invoAppvInfo);
			webInvoiceMapper.updateAppvInfo(invoAppvInfo);
			webInvoiceMapper.updateAppvLine(invoAppvInfo);
			webInvoiceMapper.insertNotification(invoAppvInfo);

			Map<String, Object> emailDetail = new HashMap<String,Object>();
			emailDetail.put("clmNo",invoAppvInfo.get("clmNo").toString());
			emailDetail.put("reqstUserId",invoAppvInfo.get("reqstUserId").toString());
			emailDetail.put("reqstDt",invoAppvInfo.get("reqstDt").toString());
			EgovMap userDetail = webInvoiceMapper.selectUserDetail(emailDetail);
			emailDetail.put("appvPrcssStus", "J");
			emailDetail.put("isResubmitAllowed", params.get("isResubmitAllowed"));
			emailDetail.put("email",userDetail.get("userEmail").toString());
			emailDetailList.add(emailDetail);
		}

		sendEmail(emailDetailList);
	}

	@Override
	public List<EgovMap> selectSupplier(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectSupplier(params);
	}

	@Override
	public List<EgovMap> selectCostCenter(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectCostCenter(params);
	}

	@Override
	public List<EgovMap> selectTaxCodeWebInvoiceFlag() {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectTaxCodeWebInvoiceFlag();
	}

	@Override
	public String selectNextClmNo() {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectNextClmNo();
	}

	@Override
	public String selectNextAppvPrcssNo() {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectNextAppvPrcssNo();
	}

	@Override
	public List<Object> budgetCheck(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<Object> list = new ArrayList<Object>();
		List<Object> newGridList = (List<Object>) params.get("newGridList");
		for(int i = 0; i < newGridList.size(); i++) {
			Map<String, Object> data = (Map<String, Object>) newGridList.get(i);
			data.put("year", params.get("year"));
			data.put("month", params.get("month"));
			data.put("costCentr", params.get("costCentr"));
			LOGGER.debug("data =====================================>>  " + data);
			String yN = webInvoiceMapper.budgetCheck(data);
			LOGGER.debug("yN =====================================>>  " + yN);
			if("N".equals(yN)) {
				list.add(data.get("clmSeq"));
			}
		}

		LOGGER.debug("list =====================================>>  " + list);
		LOGGER.debug("list.size() =====================================>>  " + list.size());

		return list;
	}

	@Override
	public String getAppvPrcssStus(List<EgovMap> appvLineInfo, List<EgovMap> appvInfoAndItems) {
		// TODO Auto-generated method stub
		LOGGER.debug("appvInfoAndItems =====================================>>  " + appvInfoAndItems);

		// appvInfo get
		EgovMap appvInfo = appvInfoAndItems.get(0);
		String reqstUserId = (String) appvInfo.get("reqstUserId");
		String reqstDt = (String) appvInfo.get("reqstDt");
		String appvPrcssStus = "- Request By " + reqstUserId + " [" + reqstDt + "]";
		for(int i = 0; i < appvLineInfo.size(); i++) {
			EgovMap appvLine = appvLineInfo.get(i);
			String appvStus = (String) appvLine.get("appvStus");
//			String appvLineUserId = (String) appvLine.get("appvLineUserId");
			String appvLineUserName = (String) appvLine.get("appvLineUserName");
			String appvDt = (String) appvLine.get("appvDt");
			if("R".equals(appvStus) || "T".equals(appvStus)) {
				appvPrcssStus += "<br> - Pending By " + appvLineUserName;
			} else if ("A".equals(appvStus)) {
				appvPrcssStus += "<br> - Approval By " + appvLineUserName + " [" + appvDt + "]";
			} else if ("J".equals(appvStus)) {
				appvPrcssStus += "<br> - Reject By " + appvLineUserName + " [" + appvDt + "]";
			}
		}
		LOGGER.debug("appvPrcssStus =====================================>>  " + appvPrcssStus);
		return appvPrcssStus;
	}

	@Override
	public void updateWebInvoiceInfoTotAmt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		webInvoiceMapper.updateWebInvoiceInfoTotAmt(params);
	}

	@Override
	public List<EgovMap> selectBudgetCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectBudgetCodeList(params);
	}

	@Override
	public List<EgovMap> selectGlCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectGlCodeList(params);
	}

	@Override
	public EgovMap selectTaxRate(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectTaxRate(params);
	}

	@Override
	public EgovMap selectClamUn(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectClamUn(params);
	}

	@Override
	public void updateClamUn(Map<String, Object> params) {
		// TODO Auto-generated method stub
		webInvoiceMapper.updateClamUn(params);
	}

	@Override
	public String selectSameVender(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectSameVender(params);
	}

	@Override
	public List<EgovMap> getAppvExcelInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.getAppvExcelInfo(params);
	}

	@Override
	public String selectHrCodeOfUserId(String userId) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectHrCodeOfUserId(userId);
	}

	@Override
	public int selectAppvStus(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAppvStus(param);
	}

    @Override
    public void editRejected(Map<String, Object> params) {
        // TODO Auto-generated method stub

        LOGGER.debug("editRejected =====================================>>  " + params);

        webInvoiceMapper.insertRejectM(params);

        webInvoiceMapper.insertRejectD(params);

    }

    @Override
    public EgovMap getDtls(Map<String, Object> params) {
        return webInvoiceMapper.getDtls(params);
    }

    @Override
    public EgovMap getCostCenterName(Map<String, Object> params) {
        return webInvoiceMapper.getCostCenterName(params);
    }

    @Override
    public EgovMap getApprGrp(Map<String, Object> params) {
        return webInvoiceMapper.getApprGrp(params);
    }

    @Override
    public EgovMap getFinalApprAct(Map<String, Object> params) {
        return webInvoiceMapper.getFinalApprAct(params);
    }

    @Override
    public EgovMap getFinApprover(Map<String, Object> params) {
        return webInvoiceMapper.getFinApprover(params);
    }

    @Override
    public String selectNextAppvIfKey() {
        return webInvoiceMapper.selectNextAppvIfKey();
    }

    @Override
    public int checkExistClmNo(String clmNo) {
        return webInvoiceMapper.checkExistClmNo(clmNo);
    }

    @Override
    public List<EgovMap> selectAtchFileData(Map<String, Object> params) {
      // TODO Auto-generated method stub
      return webInvoiceMapper.selectAtchFileData(params);
    }

    @Override
    public String selectFCM12Data(Map<String, Object> params) {
      // TODO Auto-generated method stub
      return webInvoiceMapper.selectFCM12Data(params);
    }

    private void sendEmail(List<Map<String, Object>> params) {
    	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    	for(int i = 0 ;i< params.size();i++){
            EmailVO email = new EmailVO();
            Date requestDate = null;
            Timestamp timestamp = null;
            if(params.get(i).get("reqstDt").toString().contains("/")){
            	try {
					requestDate = dateFormat.parse((String) params.get(i).get("reqstDt"));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
            }
            else{
            	timestamp = new Timestamp(Long.parseLong((String) params.get(i).get("reqstDt")));
                requestDate = new Date(timestamp.getTime());
            }
            String emailSubject = "";

            List<String> emailNo = new ArrayList<String>();

            if (!"".equals(CommonUtils.nvl(params.get(i).get("email")))) {
            	emailNo.add(CommonUtils.nvl(params.get(i).get("email")));
            }

            String clmType = params.get(i).get("clmNo").toString().substring(0, 2);
            String[] advanceClmType = {"A1", "R2", "A2", "R3", "A3", "R4"};
            boolean advanceType = Arrays.stream(advanceClmType).anyMatch(clmType::contains); //check if clmType fall into any of the advanceClmType
            String content = "";

            if(clmType != null && advanceType){ //when is advance claim type

            	switch(clmType){
            		case "A1" :
            			emailSubject = "[Rejection] Repayment for Staff Travel Advance No: ";
            			break;
            		case "R2" :
            			emailSubject = "[Rejection] Request for Staff Travel Advance No: ";
            			break;
            		case "A2" :
            			emailSubject = "[Rejection] Repayment for Staff Business Activity No: ";
            			break;
            		case "R3" :
            			emailSubject = "[Rejection] Request for Staff Business Activity No: ";
            			break;
            		case "A3" :
            			emailSubject = "[Rejection] Repayment for Vendor Advance No: ";
            			break;
            		case "R4" :
            			emailSubject = "[Rejection] Request for Vendor Advance No: ";
            			break;
            	}

            	emailSubject += params.get(i).get("clmNo").toString();
            	content += "Dear Sir/Madam,<br/>";
            	if(CommonUtils.nvl(params.get(i).get("appvPrcssStus")) == "J"){
                	String isResubmitAllowed = CommonUtils.nvl(params.get(i).get("isResubmitAllowed"));
                    if(isResubmitAllowed.equals("0")) {
                    	content += "Claim No " + params.get(i).get("clmNo").toString() + " Submitted on date " + dateFormat.format(requestDate) + " has been rejected, kindly resubmit ASAP. <br/><br/>";
                    }
                    else{
                        content += "Claim No " + params.get(i).get("clmNo").toString() + " Submitted on date " + dateFormat.format(requestDate) + " has been rejected. Kindly resubmit (edit rejected) your document. <br/><br/>";
                    }
                }
            }
            else{
            	emailSubject = "Reminder/Notification for e-claim document";
            	content += "Dear Sir/Madam,<br/>";
                if(CommonUtils.nvl(params.get(i).get("appvPrcssStus")) == "A"){
                	content += "Claim No " + params.get(i).get("clmNo").toString() + " Submitted on date " + dateFormat.format(requestDate) + " has been approved.<br/><br/>";
                }  else if(CommonUtils.nvl(params.get(i).get("appvPrcssStus")) == "J"){
                	String isResubmitAllowed = CommonUtils.nvl(params.get(i).get("isResubmitAllowed"));
                    if(isResubmitAllowed.equals("0")) {
                    	content += "Claim No " + params.get(i).get("clmNo").toString() + " Submitted on date " + dateFormat.format(requestDate) + " has been rejected.<br/><br/>";
                    }
                    else{
                        content += "Claim No " + params.get(i).get("clmNo").toString() + " Submitted on date " + dateFormat.format(requestDate) + " has been rejected. Kindly resubmit your document no later than two (2)";
                        content += " months from the receipt month.<br/><br/>";
                    }
                }
            }

            email.setTo(emailNo);
            email.setHtml(true);
            email.setSubject(emailSubject);
            email.setText(content);
            adaptorService.sendEmail(email, false);
    	}
    }
}
