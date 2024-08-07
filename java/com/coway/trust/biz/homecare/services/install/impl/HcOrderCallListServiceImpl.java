package com.coway.trust.biz.homecare.services.install.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.services.install.HcOrderCallListService;
import com.coway.trust.biz.organization.organization.BranchListService;
import com.coway.trust.biz.organization.organization.impl.AllocationMapper;
import com.coway.trust.biz.organization.organization.orgUts.VComparator;
import com.coway.trust.biz.services.orderCall.OrderCallListService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.services.installation.InstallationResultListController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("hcOrderCallListService")
public class HcOrderCallListServiceImpl extends EgovAbstractServiceImpl implements HcOrderCallListService {

	  private static final Logger logger = LoggerFactory.getLogger(InstallationResultListController.class);

	@Resource(name = "orderCallListService")
	private OrderCallListService orderCallListService;

	@Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;

	@Resource(name = "hcOrderCallListMapper")
	private HcOrderCallListMapper hcOrderCallListMapper;

	@Resource(name = "allocationMapper")
	private AllocationMapper allocationMapper;

	@Resource(name = "hcAllocationMapper")
	private HcAllocationMapper hcAllocationMapper;

	@Resource(name = "branchListService")
	private BranchListService branchListService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	  private AdaptorService adaptorService;

	/**
	 * Save Call Log Result [ENHANCE OLD insertCallResult]
	 * @Author KR-SH
	 * @Date 2019. 12. 11.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.services.install.HcOrderCallListService#hcInsertCallResult(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public ReturnMessage hcInsertCallResult(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage rtnMsg = new ReturnMessage();
		params.put("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);

		ReturnMessage message1 = hcInsertCallSave(params, sessionVO);

		// selected order call save
		if(AppConstants.FAIL.equals(message1.getCode())) {
			throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(message1.getMessage()));
		}

		// another order call save
		String anoOrdNo = CommonUtils.nvl(params.get("anoOrdNo"));

		if(!"".equals(anoOrdNo)) {
			Map<String, Object> anotherOrd = new HashMap<String, Object>();
			anotherOrd.put("orderNo", anoOrdNo);
			anotherOrd.put("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
			anotherOrd.put("callStusId", CommonUtils.nvl(params.get("callStusId")));

			// Added for Air Conditioner Project, Hui Ding, 16/01/2023
			String[] branchTypeArray = {HomecareConstants.HDC_BRANCH_TYPE, HomecareConstants.DSC_BRANCH_TYPE};

			anotherOrd.put("branchTypeList", branchTypeArray);

			Map<String, Object> orderCallOrd = selectHcOrderCall(anotherOrd);

			params.put("callStusCode", CommonUtils.nvl(orderCallOrd.get("callStusCode")));
			params.put("callStusId", CommonUtils.nvl(orderCallOrd.get("callStusId")));
			params.put("salesOrdId", CommonUtils.nvl(orderCallOrd.get("salesOrdId")));
			params.put("callEntryId", CommonUtils.nvl(orderCallOrd.get("callEntryId")));
			params.put("salesOrdNo", CommonUtils.nvl(orderCallOrd.get("salesOrdNo")));
			params.put("rcdTms", CommonUtils.nvl(orderCallOrd.get("rcdTms")));
			params.put("callTypeId", CommonUtils.nvl(orderCallOrd.get("callTypeId")));
			params.put("hiddenProductId", CommonUtils.nvl(orderCallOrd.get("c4")));

			ReturnMessage message2 = hcInsertCallSave(params, sessionVO);

			// selected order call save
			if(AppConstants.FAIL.equals(message2.getCode())) {
				throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(message2.getMessage()));
			}
		}

		rtnMsg.setCode(AppConstants.SUCCESS);
		rtnMsg.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	    return rtnMsg;
	}

	/**
	 * Select Homecare Order Call
	 * @Author KR-SH
	 * @Date 2019. 12. 11.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.install.HcOrderCallListService#selectHcOrderCall(java.util.Map)
	 */
	@Override
	public Map<String, Object> selectHcOrderCall(Map<String, Object> params) {
		return hcOrderCallListMapper.selectHcOrderCall(params);
	}

	/**
	 * Save Call Log
	 * @Author KR-SH
	 * @Date 2019. 12. 11.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public ReturnMessage hcInsertCallSave(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
	    Map<String, Object> resultValue = new HashMap<String, Object>();
	    Map<String, Object> smsResultValue = new HashMap<String, Object>();
	    int noRcd = orderCallListService.chkRcdTms(params);

	    if (noRcd == 1) { // RECORD ABLE TO UPDATE
	    	EgovMap orderCall = orderCallListService.getOrderCall(params);
	    	params.put("productCode", CommonUtils.nvl(orderCall.get("productCode")));

	    	// Added for Air Con Project by Hui Ding, 20230113
	    	params.put("productCat", CommonUtils.nvl(orderCall.get("productCat")));

	     	EgovMap rdcStock = orderCallListService.selectRdcStock(params);

	     	if (CommonUtils.intNvl(params.get("callStatus")) == 20) {
	     		if (rdcStock != null) {
	     			if (CommonUtils.intNvl(rdcStock.get("availQty")) > 0) {
	     				resultValue = orderCallListService.insertCallResultSerial(params, sessionVO);

	     				if (null != resultValue) {
     						if ("1".equals(resultValue.get("logStat"))) {
     							message.setMessage("Error Encounter. Please Contact Administrator. Error Code(CL): " + CommonUtils.nvl(resultValue.get("logStat")));
     							message.setCode(AppConstants.FAIL);
     						} else {
     		                	  String msg = "Record created successfully.</br> Installation No : " + resultValue.get("installationNo") + "</br>Seles Order No : " + resultValue.get("salesOrdNo");

     							 try{
     		                		  smsResultValue = hcCallLogSendSMS(params, sessionVO);
     		                	  }catch (Exception e){

     		                	  }
     		                	  if(smsResultValue.isEmpty()){
     		                		  msg += "</br> Failed to send SMS to " + params.get("custMobileNo").toString();
     		                	  }

     		                	message.setMessage(msg);
     							message.setCode(AppConstants.SUCCESS);
     						}
	     				}

	     			} else {
	     				message.setMessage("Fail to update due to RDC out of stock. ");
	     				message.setCode(AppConstants.FAIL);
	     			}

	     		} else {
	     			message.setMessage("Fail to update due to RDC out of stock. ");
	     			message.setCode(AppConstants.FAIL);
	     		}

	     	} else {
	     		resultValue = orderCallListService.insertCallResultSerial(params, sessionVO);

	     		if (null != resultValue) {
	     			message.setMessage("Record updated successfully.</br> ");
	     			message.setCode(AppConstants.SUCCESS);
	     		}
	     	}

	    } else {
	    	message.setMessage("Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
	    	message.setCode(AppConstants.FAIL);
	    }

	    return message;
	}

	/**
	 * Select organization territoryList page (Homecare)
	 * @Author KR-SH
	 * @Date 2019. 12. 12.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.install.HcOrderCallListService#hcInsertCallResult(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<EgovMap> hcInsertCallResult(Map<String, Object> params) throws Exception {
		List<EgovMap> baseList = null;
		List<EgovMap> rtnList = null;
		List<EgovMap> fList = null;
		List<EgovMap> mergeHolidayList = null;
		List<EgovMap> mergeVacationList = null;
		List<EgovMap> mergeNoSvcList = null;

		//Level 1  getBaseList   CT_SUB_GRP
		baseList = selectBaseList(params);
		//getBaseList   CT_SUB_GRP

		//Level 2
		if(null != baseList) {
			if(baseList.size() > 0) {
				mergeHolidayList  = new ArrayList<EgovMap>();

				 for (Iterator<EgovMap> iterator = baseList.iterator(); iterator.hasNext();) {
					 EgovMap   holiDayAddMap =  new EgovMap();
    				 EgovMap e = iterator.next();

    				 holiDayAddMap.put("ct", CommonUtils.nvl(e.get("ct")));
    				 holiDayAddMap.put("cDate", CommonUtils.nvl(e.get("cDate")));
    				 holiDayAddMap.put("ctSubGrp", CommonUtils.nvl(e.get("ctSubGrp")));
    				 holiDayAddMap.put("brnchId", CommonUtils.nvl(e.get("brnchId")));
    				 holiDayAddMap.put("holiday", CommonUtils.nvl(e.get("cDate")));

    				 try {
    					 // KR. JIN. - 2019-11-25
    					 List<EgovMap> vm = allocationMapper.isHcSubGroupHoliDay(holiDayAddMap);

    					 if(null != vm && vm.size() > 0) {
    						 for(EgovMap em : vm) {
    							 EgovMap   hMap =  new EgovMap();

    							 hMap.put("isHoliDay", "true");
    							 hMap.put("holiDayCtCode", CommonUtils.nvl(em.get("memId")));
    							 hMap.put("ct", CommonUtils.nvl(em.get("memId")));
    							 hMap.put("oldCt", CommonUtils.nvl(e.get("ct")));
    							 hMap.put("cDate", CommonUtils.nvl(holiDayAddMap.get("cDate")));
    							 hMap.put("ctSubGrp", CommonUtils.nvl(holiDayAddMap.get("ctSubGrp")));
    							 hMap.put("brnchId", CommonUtils.nvl(holiDayAddMap.get("brnchId")));

    							 mergeHolidayList.add(hMap);
    						 }

    					 } else {
    						 holiDayAddMap.put("isHoliDay", "false");
    						 holiDayAddMap.put("holiDayCtCode", "");

    						 mergeHolidayList.add(holiDayAddMap);
    					 }

    				 } catch(Exception ex) {
    					 holiDayAddMap.put("isHoliDay", "false");
    					 mergeHolidayList.add(holiDayAddMap);
					 }

				} // eof mergeHolidayList
			}
		}// eof baseList

		//Level 3
		if(null != mergeHolidayList) {
			if(mergeHolidayList.size() > 0) {
				mergeVacationList = new ArrayList<EgovMap>();

				for (Iterator<EgovMap> iterator = mergeHolidayList.iterator(); iterator.hasNext();) {
					EgovMap vacationAddMap = new EgovMap();
                    EgovMap e = iterator.next();

                    vacationAddMap.put("ct", CommonUtils.nvl(e.get("ct")));
                    vacationAddMap.put("cDate", CommonUtils.nvl(e.get("cDate")));
                    vacationAddMap.put("ctSubGrp", CommonUtils.nvl(e.get("ctSubGrp")));
                    vacationAddMap.put("brnchId", CommonUtils.nvl(e.get("brnchId")));
                    vacationAddMap.put("isHoliDay", CommonUtils.nvl(e.get("isHoliDay")));
                    vacationAddMap.put("holiDayCtCode", CommonUtils.nvl(e.get("holiDayCtCode")));
                    vacationAddMap.put("oldCt", CommonUtils.nvl(e.get("oldCt")));

                    vacationAddMap.put("vactReplCt", CommonUtils.nvl(e.get("ct")));
                    vacationAddMap.put("rDate", CommonUtils.nvl(e.get("cDate")));

                    try {
                    	EgovMap vm = allocationMapper.selectVacationList(vacationAddMap);

                    	if(null != vm) {
                            vacationAddMap.put("isVact", "true");
                            vacationAddMap.put("vactReplCt", CommonUtils.nvl(vm.get("vactReplCt")));
                            vacationAddMap.put("ct", CommonUtils.nvl(vm.get("vactReplCt")));

                    	} else {
                    		vacationAddMap.put("isVact", "false");
                    		vacationAddMap.put("vactReplCt", "");
                    	}

                    } catch(Exception ex) {
                    	vacationAddMap.put("isVact", "false");
                    }

                    mergeVacationList.add(vacationAddMap);
				 } // eof mergeVacationList
			}
		}

		//Level 4 - no Service day  : KR. JIN. - 2020.01.04
		if(null != mergeVacationList) {
			if(mergeVacationList.size() > 0) {
				mergeNoSvcList = new ArrayList<EgovMap>();

				for (Iterator<EgovMap> iterator = mergeVacationList.iterator(); iterator.hasNext();) {
					EgovMap noSvcListMap = new EgovMap();
                    EgovMap e = iterator.next();

                    noSvcListMap.put("ct", CommonUtils.nvl(e.get("ct")));
                    noSvcListMap.put("cDate", CommonUtils.nvl(e.get("cDate")));
                    noSvcListMap.put("ctSubGrp", CommonUtils.nvl(e.get("ctSubGrp")));
                    noSvcListMap.put("brnchId", CommonUtils.nvl(e.get("brnchId")));
                    noSvcListMap.put("isHoliDay", CommonUtils.nvl(e.get("isHoliDay")));
                    noSvcListMap.put("holiDayCtCode", CommonUtils.nvl(e.get("holiDayCtCode")));
                    noSvcListMap.put("oldCt", CommonUtils.nvl(e.get("oldCt")));
                    noSvcListMap.put("isVact", CommonUtils.nvl(e.get("isVact")));
                    noSvcListMap.put("vactReplCt", CommonUtils.nvl(e.get("vactReplCt")));
                    noSvcListMap.put("ordId", params.get("ORD_ID"));

                    EgovMap branchDetail = branchListService.getBranchDetailPop(noSvcListMap);
                    String vPrdType = branchDetail.get("typeId").toString().equals("43") ? "7321" : "6666";

                    noSvcListMap.put("prdType", vPrdType); // Homecare

    				try {
    					int vm = allocationMapper.isMergeNosvcDay(noSvcListMap);

    					if(vm > 0) {
    						noSvcListMap.put("isNoSvcDay", "true");
							mergeNoSvcList.add(noSvcListMap);

    					} else {
    						noSvcListMap.put("isNoSvcDay", "false");
    						mergeNoSvcList.add(noSvcListMap);
    					}

    				} catch(Exception ex) {
    					noSvcListMap.put("isNoSvcDay", "false");
    				}
    				mergeNoSvcList.add(noSvcListMap);
				} // eof mergeHolidayList
			}
		}

		//level 5  setViewList
		rtnList = new ArrayList<EgovMap>();
		fList= new ArrayList<EgovMap>();

		if(null != mergeNoSvcList) {
			if(mergeNoSvcList.size() > 0) {
				for (Iterator<EgovMap> iterator = mergeNoSvcList.iterator(); iterator.hasNext();) {
					EgovMap v = iterator.next();

					if( "true".equals(CommonUtils.nvl(v.get("isVact"))) || "true".equals(CommonUtils.nvl(v.get("isNoSvcDay"))) ){
						continue;
					}

					if( "true".equals(CommonUtils.nvl(v.get("isHoliDay"))) ){
						v.put("repla", "true");
					}else{
						v.put("repla", "false");
					}

					EgovMap eM = hcAllocationMapper.makeViewList(v);
					fList.add(eM);

				}
			}
		}

		//level5  중복 제거
		HashSet<EgovMap> hs = new HashSet<EgovMap>(fList);
		Iterator<EgovMap> it = hs.iterator();

		while(it.hasNext()) {
			rtnList.add((EgovMap)it.next());
		}
		Collections.sort(rtnList, new VComparator());

		return rtnList;
	}

	/**
	 * TO-DO Description
	 * @Author KR-SH
	 * @Date 2019. 12. 12.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.install.HcOrderCallListService#selectBaseList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectBaseList(Map<String, Object> params) {
		return hcOrderCallListMapper.selectBaseList(params);
	}

	/**
	 * Search Order Call List
	 * @Author KR-SH
	 * @Date 2019. 12. 26.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.install.HcOrderCallListService#searchHcOrderCallList(java.util.Map)
	 */
	@Override
	public List<EgovMap> searchHcOrderCallList(Map<String, Object> params) {
		return hcOrderCallListMapper.searchHcOrderCallList(params);
	}


	@Override
	public List<EgovMap> selectHcDetailList(Map<String, Object> params) throws Exception{
		return hcAllocationMapper.selectHcDetailList(params);
	}

	@Override
	public Map<String, Object> hcCallLogSendSMS(Map<String, Object> params, SessionVO sessionVO) {
		Map<String, Object> smsResultValue = new HashMap<String, Object>();
		String smsMessage = "";

        logger.debug("===params=== " + params.toString());

		try{
		  //SMS for OrderCall Appointment
		    smsMessage = "COWAY: Order " + params.get("salesOrdNo").toString() + ", janji temu anda utk pemasangan produk akan ditetapkan. Sebarang pertanyaan, sila hubungi 1800-888-111.";

		    params.put("chkSMS", CommonUtils.nvl(params.get("chkSMS"))); //to prevent untick SMS

		       if(params.get("apptypeId").equals("66") || params.get("apptypeId").equals("67") || params.get("apptypeId").equals("68")
		    		   || params.get("apptypeId").equals("5764"))//IF APPTYPE = RENTAL/OUTRIGHT/INSTALLMENT/AUX
		       {
		    	   if(params.get("callStatus").equals("20") && params.get("feedBackCode").equals("225") //IF CALL LOG STATUS == READY TO INSTALL, IF FEEDBACK CODE == READY TO DO
		    			   && params.get("custType").equals("Individual") && params.get("chkSMS").equals("on")){ //IF CUST_TYPE = INDIVIDUAL , IF CHECKED SMS CHECKBOX)

		           	       Map<String, Object> smsList = new HashMap<>();
		                   smsList.put("userId", sessionVO.getUserId());
		                   smsList.put("smsType", 975);
		                   smsList.put("smsMessage", smsMessage);
		                   smsList.put("smsMobileNo", params.get("custMobileNo").toString());

		                   sendSms(smsList);
		    	   }
		      }
		    }catch(Exception e){
		    	smsResultValue.put("smsLogStat", "3");
		    }

		smsResultValue.put("smsLogStat", "0");//if success
		return smsResultValue;
	}

	 @Override
	  public void sendSms(Map<String, Object> smsList){
	    int userId = (int) smsList.get("userId");
	    SmsVO sms = new SmsVO(userId, 975);

	    sms.setMessage(smsList.get("smsMessage").toString());
	    sms.setMobiles(smsList.get("smsMobileNo").toString());
	    //send SMS
	    SmsResult smsResult = adaptorService.sendSMS(sms);
	  }
}
