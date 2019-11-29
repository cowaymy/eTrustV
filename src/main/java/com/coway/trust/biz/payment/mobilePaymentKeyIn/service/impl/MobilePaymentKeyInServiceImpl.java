package com.coway.trust.biz.payment.mobilePaymentKeyIn.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.MobileAppTicketApiCommonMapper;
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.payment.common.service.impl.CommonPaymentMapper;
import com.coway.trust.biz.payment.mobilePaymentKeyIn.service.MobilePaymentKeyInService;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobilePaymentKeyInServiceImpl.java
 * @Description : MobilePaymentKeyInServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 21.   KR-HAN        First creation
 * </pre>
 */
@Service("mobilePaymentKeyInService")
public class MobilePaymentKeyInServiceImpl extends EgovAbstractServiceImpl implements MobilePaymentKeyInService{

	@Resource(name = "mobilePaymentKeyInMapper")
	private MobilePaymentKeyInMapper mobilePaymentKeyInMapper ;

	@Resource(name = "mobileAppTicketApiCommonMapper")
	private MobileAppTicketApiCommonMapper mobileAppTicketApiCommonMapper;

	@Resource(name = "commonPaymentMapper")
	private CommonPaymentMapper commonPaymentMapper;

	@Resource(name = "commonPaymentService")
	private CommonPaymentService commonPaymentService;

	@Override
	public List<EgovMap> selectMobilePaymentKeyInList(Map<String, Object> params) {

		return mobilePaymentKeyInMapper.selectMobilePaymentKeyInList(params);
	}

    @Override
    public int saveMobilePaymentKeyInReject(Map<String, Object> param) throws Exception{
        if( StringUtils.isEmpty( param.get("mobPayNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Number value.");
        }
       /* if( StringUtils.isEmpty( param.get("reqStusId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Status value.");
        }*/
        if( StringUtils.isEmpty( param.get("userId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
        }


      /*  if( !StringUtils.isEmpty( param.get("etc") )){
            throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
        }*/
        int saveCnt = mobilePaymentKeyInMapper.updateMobilePaymentKeyInReject(param);

        // 티겟 상태 변경
        Map<String, Object> ticketParam = new HashMap<String, Object>();
        ticketParam.put("ticketStusId", 6);
        ticketParam.put("updUserId", param.get("userId") );
        ticketParam.put("mobTicketNo", param.get("mobTicketNo") );
        mobileAppTicketApiCommonMapper.update(ticketParam);

        return saveCnt;
    }

    /**
     * TO-DO Description
     * @Author KR-HAN
     * @Date 2019. 11. 19.
     * @param params
     * @param sUserId
     * @return
     * @see com.coway.trust.biz.payment.mobilePaymentKeyIn.service.MobilePaymentKeyInService#saveMobilePaymentKeyInCard(java.util.Map, java.lang.String)
     */
    @Override
	public List<EgovMap>  saveMobilePaymentKeyInCard(Map<String, Object> params,  String sUserId ) {


    	Map<String, Object> gridList = ( Map<String, Object> ) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	List<Object> gridFormList = (List<Object>) params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

    	List<Object> formList = new ArrayList<Object>();

    	// 그리드 값 조회 후 다시 셋팅
    	//Payment - Order Info 조회 : order No로 Order ID 조회하기
    	params.put("ordNo", gridList.get("salesOrdNo"));
    	EgovMap resultMap = commonPaymentService.selectOrdIdByNo(params);

    	System.out.println( "++++ resultMap ::" + resultMap.toString() );

    	BigDecimal salesOrdId  = (BigDecimal) resultMap.get("salesOrdId");
    	String salesOrdNo = (String) resultMap.get("salesOrdNo");

    	params.put("orderId", salesOrdId);
    	params.put("salesOrdId", salesOrdId);

    	// 주문 렌탈 정보 조회.
		List<EgovMap> orderInfoRentalList = commonPaymentService.selectOrderInfoRental(params); // targetRenMstGridID

//		System.out.println("++++ orderInfoRentalList ::" + orderInfoRentalList.toString() );

		// Payment - Bill Info Rental 조회
       double rpf =  (double) orderInfoRentalList.get(0).get("rpf");
       double rpfPaid =  (double) orderInfoRentalList.get(0).get("rpfPaid");

       String excludeRPF = (rpf > 0 && rpfPaid >= rpf) ? "N" : "Y";
       if (rpf == 0) excludeRPF = "N";

//       System.out.println("++++ excludeRPF ::" + excludeRPF );

       params.put("excludeRPF", excludeRPF);
		List<EgovMap> billInfoRentalList = commonPaymentService.selectBillInfoRental(params); // targetRenDetGridID

    	// checkOrderOutstanding 정보 조회
    	EgovMap targetOutMstResult = commonPaymentService.checkOrderOutstanding(params); // targetOutMstGridID

    	if( "ROOT_1".equals(targetOutMstResult.get("rootState"))  ){
    		System.out.println("++ No Outstanding" + targetOutMstResult.get("msg"));
    	}

//        String mstChkVal = (String) orderInfoRentalList.get(0).get("btnCheck");
//        String salesOrdNo = (String) orderInfoRentalList.get(0).get("salesOrdNo");
        Double mstRpf = (Double) orderInfoRentalList.get(0).get("rpf");
        Double mstRpfPaid = (Double) orderInfoRentalList.get(0).get("rpfPaid");

        String mstCustNm = (String) orderInfoRentalList.get(0).get("custNm");
        BigDecimal mstCustBillId = (BigDecimal) orderInfoRentalList.get(0).get("custBillId");


        Map<String, Object> formMap = null;

        int maxSeq = 0;

//        System.out.println("++++ orderInfoRentalList.size() ::" + orderInfoRentalList.size() );

        for (int j = 0; j < orderInfoRentalList.size(); j++) {
//            if( "1".equals(mstChkVal) ){
            	if(mstRpf - mstRpfPaid > 0){
            		formMap =  new HashMap<String, Object>();

            		 formMap.put("procSeq",1);
                     formMap.put("appType", "RENTAL");
                     formMap.put("advMonth",  (Integer)gridList.get("advMonth"));						// 셋팅필요
                     formMap.put("mstRpf", mstRpf);
                     formMap.put("mstRpfPaid", mstRpfPaid);

                     formMap.put("assignAmt", 0);
                     formMap.put("billAmt", mstRpf);
                     formMap.put("billDt", "1900-01-01");
                     formMap.put("billGrpId", mstCustBillId);
                     formMap.put("billId", 0);
                     formMap.put("billNo", "0");
                     formMap.put("billStatus", "");
                     formMap.put("billTypeId", 161);
                     formMap.put("billTypeNm", "RPF");
                     formMap.put("custNm", mstCustNm);
                     formMap.put("discountAmt", 0);
                     formMap.put("installment", 0);
                     formMap.put("ordId", salesOrdId);
                     formMap.put("ordNo", salesOrdNo);
                     formMap.put("paidAmt", "mstRpfPaid");
                     formMap.put("targetAmt", mstRpf - mstRpfPaid);
                     formMap.put("srvcContractID", 0);
                     formMap.put("billAsId", 0);
    				 formMap.put("srvMemId", 0);
//                     item. =  $("#rentalkeyInTrNo").val() ;
                     formMap.put("trNo", ""); //
//                     item. =  $("#rentalkeyInTrIssueDate").val() ;
                     formMap.put("trDt", ""); //
//                     item.collectorCode =  $("#rentalkeyInCollMemNm").val()
                     formMap.put("collectorCode", ""); //
//                     item.collectorId = $("#rentalkeyInCollMemId").val() ;
                     formMap.put("collectorId", "");
//                     item.allowComm = $("#rentalcashIsCommChk").val()
            		 formMap.put("allowComm", "1");

            		 formList.add(formMap);
            	}

            	int detailRowCnt = billInfoRentalList.size();

                for(j = 0 ; j < detailRowCnt ; j++){
                	Map billInfoRentalMap = billInfoRentalList.get(j);
//                    String detChkVal = (String) billInfoRentalMap.get("btnCheck");
                    String detSalesOrdNo = (String) billInfoRentalMap.get("ordNo");



                    if(salesOrdNo.equals(detSalesOrdNo)){
                    	formMap =  new HashMap<String, Object>();

                        formMap.put("procSeq", 1);
                        formMap.put("appType", "RENTAL");
                        formMap.put("advMonth",  (Integer)gridList.get("advMonth"));						// 셋팅필요
                        formMap.put("mstRpf", mstRpf);
                        formMap.put("mstRpfPaid", mstRpfPaid);

                        formMap.put("assignAmt",0);
                        formMap.put("billAmt", billInfoRentalMap.get("billAmt"));
                        formMap.put("billDt", billInfoRentalMap.get("billDt"));
                        formMap.put("billGrpId", billInfoRentalMap.get("billGrpId"));
                        formMap.put("billId", billInfoRentalMap.get("billId"));
                        formMap.put("billNo", billInfoRentalMap.get("billNo"));
                        formMap.put("billStatus", billInfoRentalMap.get("stusCode"));
                        formMap.put("billTypeId", billInfoRentalMap.get("billTypeId"));
                        formMap.put("billTypeNm", billInfoRentalMap.get("billTypeNm"));
                        formMap.put("custNm", billInfoRentalMap.get("custNm"));
                        formMap.put("discountAmt", 0);
                        formMap.put("installment", billInfoRentalMap.get("installment"));
                        formMap.put("ordId", billInfoRentalMap.get("ordId"));
                        formMap.put("ordNo", billInfoRentalMap.get("ordNo"));
                        formMap.put("paidAmt", billInfoRentalMap.get("paidAmt"));
                        formMap.put("appType",  "RENTAL");
                        formMap.put("targetAmt", billInfoRentalMap.get("targetAmt"));
                        formMap.put("srvcContractID", 0);
                        formMap.put("billAsId", 0);
						formMap.put("srvMemId", 0);

//	                     item. =  $("#rentalkeyInTrNo").val() ;
	                     formMap.put("trNo", ""); //
//	                     item. =  $("#rentalkeyInTrIssueDate").val() ;
	                     formMap.put("trDt", ""); //
//	                     item.collectorCode =  $("#rentalkeyInCollMemNm").val()
	                     formMap.put("collectorCode", ""); //
//	                     item.collectorId = $("#rentalkeyInCollMemId").val() ;
	                     formMap.put("collectorId", "");
//	                     item.allowComm = $("#rentalcashIsCommChk").val()
	            		 formMap.put("allowComm", "");

	            		 formList.add(formMap);
                    }
                }

                //Advance Month
//                if( StringUtils.isEmpty(gridList.get("advMonth"))  != "" && (Integer)gridList.get("advMonth") >= 0){
                if( !StringUtils.isEmpty(gridList.get("advMonth"))){
                	formMap =  new HashMap<String, Object>();

                    formMap.put("procSeq", 1);
                    formMap.put("appType", "RENTAL");
                    formMap.put("advMonth", (Integer)gridList.get("advMonth"));
                    formMap.put("mstRpf", mstRpf);
                    formMap.put("mstRpfPaid", mstRpfPaid);

                    formMap.put("assignAmt",0);
                    formMap.put("billAmt", gridList.get("advAmt") );
                    formMap.put("billDt",  "1900-01-01" );
                    formMap.put("billGrpId", mstCustBillId);
                    formMap.put("billId", 0);
                    formMap.put("billNo",  "0");
                    formMap.put("billStatus", "");
                    formMap.put("billTypeId", 1032);
                    formMap.put("billTypeNm", "General Advanced For Rental");
                    formMap.put("custNm", mstCustNm);
                    formMap.put("discountAmt", 0);
                    formMap.put("installment", 0);
                    formMap.put("ordId", salesOrdId);
                    formMap.put("ordNo", salesOrdNo);
                    formMap.put("paidAmt", 0 );
                    formMap.put("appType",  "RENTAL");
                    formMap.put("targetAmt", gridList.get("payAmt"));
                    formMap.put("srvcContractID", 0);
                    formMap.put("billAsId", 0);
					formMap.put("srvMemId", 0);

//                     item. =  $("#rentalkeyInTrNo").val() ;
                     formMap.put("trNo", ""); //
//                     item. =  $("#rentalkeyInTrIssueDate").val() ;
                     formMap.put("trDt", ""); //
//                     item.collectorCode =  $("#rentalkeyInCollMemNm").val()
                     formMap.put("collectorCode", ""); //
//                     item.collectorId = $("#rentalkeyInCollMemId").val() ;
                     formMap.put("collectorId", "");
//                     item.allowComm = $("#rentalcashIsCommChk").val()
            		 formMap.put("allowComm", "");

            		 formList.add(formMap);

               }
//            }
		}

    	Map<String, Object> formInfo = new HashMap<String, Object> ();
    	if(gridFormList.size() > 0){
    		for(Object obj : gridFormList){
    			Map<String, Object> map = (Map<String, Object>) obj;
    			formInfo.put((String)map.get("name"), map.get("value"));
    		}
    	}

    	//User ID 세팅
    	formInfo.put("userid", sUserId);

    	//Credit Card일때
    	if("107".equals(String.valueOf(formInfo.get("keyInPayType")))){
    		formInfo.put("keyInIsOnline",  "1299".equals(String.valueOf(formInfo.get("keyInCardMode"))) ? 0 : 1 );
    		formInfo.put("keyInIsLock",  0);
    		formInfo.put("keyInIsThirdParty",  0);
    		formInfo.put("keyInStatusId",  1);
    		formInfo.put("keyInIsFundTransfer",  0);
    		formInfo.put("keyInSkipRecon",  0);
    		formInfo.put("keyInPayItmCardType",  formInfo.get("keyCrcCardType"));
    		formInfo.put("keyInPayItmCardMode",  formInfo.get("keyInCardMode"));

    		formInfo.put("keyInPayType",  "107" );

    		formInfo.put("keyInPayDate",  formInfo.get("keyInTrDate") ); // 임시

    	}

    	gridList.put("userId", sUserId);
    	formInfo.put("userId", sUserId);
		// 저장
//    	System.out.println("++++ formInfo ::" + formInfo.toString() );
//    	System.out.println("++++ gridList ::" + gridList.toString() );
//    	System.out.println("++++ formList ::" + formList.toString() );
//    	System.out.println("++++ gridFormList.toString() ::" + gridFormList.toString() );

//    	List<EgovMap> resultList = null;
//    	mobilePaymentKeyInService.saveMobilePaymentKeyInCard(formInfo,gridList);
    	List<EgovMap> resultList = commonPaymentService.savePayment(formInfo,formList);

    	// 상태 변경
    	mobilePaymentKeyInMapper.updateMobilePaymentKeyInUpdate(gridList);

        // 티겟 상태 변경
        Map<String, Object> ticketParam = new HashMap<String, Object>();
        ticketParam.put("ticketStusId", 5);
        ticketParam.put("updUserId", sUserId );
        ticketParam.put("mobTicketNo", gridList.get("mobTicketNo") );
        mobileAppTicketApiCommonMapper.update(ticketParam);

    	//WOR 번호 조회
    	return resultList;
    	//return rcList;
    }


    /**
     * TO-DO Description
     * @Author KR-HAN
     * @Date 2019. 11. 20.
     * @param paramMap
     * @param paramList
     * @param key
     * @return
     * @see com.coway.trust.biz.payment.mobilePaymentKeyIn.service.MobilePaymentKeyInService#saveMobilePaymentKeyInNormalPayment(java.util.Map, java.util.Map, int)
     */
    @Override
	public Map<String, Object>  saveMobilePaymentKeyInNormalPayment( Map<String, Object> params, String sUserId ) {

    	Map<String, Object> gridList = (Map<String, Object>) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	List<Object> gridFormList = (List<Object>) params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

    	// List 셋팅 시작
    	List<Object> formList = new ArrayList<Object>();

    	// 그리드 값 조회 후 다시 셋팅
    	//Payment - Order Info 조회 : order No로 Order ID 조회하기
    	params.put("ordNo", gridList.get("salesOrdNo"));
    	EgovMap resultMap = commonPaymentService.selectOrdIdByNo(params);

    	BigDecimal salesOrdId  = (BigDecimal) resultMap.get("salesOrdId");
    	String salesOrdNo = (String) resultMap.get("salesOrdNo");

    	params.put("orderId", salesOrdId);
    	params.put("salesOrdId", salesOrdId);

    	// 주문 렌탈 정보 조회.
		List<EgovMap> orderInfoRentalList = commonPaymentService.selectOrderInfoRental(params); // targetRenMstGridID

		// Payment - Bill Info Rental 조회
       double rpf =  (double) orderInfoRentalList.get(0).get("rpf");
       double rpfPaid =  (double) orderInfoRentalList.get(0).get("rpfPaid");

       String excludeRPF = (rpf > 0 && rpfPaid >= rpf) ? "N" : "Y";
       if (rpf == 0) excludeRPF = "N";

       params.put("excludeRPF", excludeRPF);
		List<EgovMap> billInfoRentalList = commonPaymentService.selectBillInfoRental(params); // targetRenDetGridID

    	// checkOrderOutstanding 정보 조회
    	EgovMap targetOutMstResult = commonPaymentService.checkOrderOutstanding(params); // targetOutMstGridID

    	if( "ROOT_1".equals(targetOutMstResult.get("rootState"))  ){
    		System.out.println("++ No Outstanding" + targetOutMstResult.get("msg"));
    	}

        Double mstRpf = (Double) orderInfoRentalList.get(0).get("rpf");
        Double mstRpfPaid = (Double) orderInfoRentalList.get(0).get("rpfPaid");

        String mstCustNm = (String) orderInfoRentalList.get(0).get("custNm");
        BigDecimal mstCustBillId = (BigDecimal) orderInfoRentalList.get(0).get("custBillId");


        Map<String, Object> formMap = null;

        int maxSeq = 0;

        for (int j = 0; j < orderInfoRentalList.size(); j++) {
//            if( "1".equals(mstChkVal) ){
            	if(mstRpf - mstRpfPaid > 0){
            		formMap =  new HashMap<String, Object>();

            		 formMap.put("procSeq",1);
                     formMap.put("appType", "RENTAL");
                     formMap.put("advMonth",  (Integer)gridList.get("advMonth"));						// 셋팅필요
                     formMap.put("mstRpf", mstRpf);
                     formMap.put("mstRpfPaid", mstRpfPaid);

                     formMap.put("assignAmt", 0);
                     formMap.put("billAmt", mstRpf);
                     formMap.put("billDt", "1900-01-01");
                     formMap.put("billGrpId", mstCustBillId);
                     formMap.put("billId", 0);
                     formMap.put("billNo", "0");
                     formMap.put("billStatus", "");
                     formMap.put("billTypeId", 161);
                     formMap.put("billTypeNm", "RPF");
                     formMap.put("custNm", mstCustNm);
                     formMap.put("discountAmt", 0);
                     formMap.put("installment", 0);
                     formMap.put("ordId", salesOrdId);
                     formMap.put("ordNo", salesOrdNo);
                     formMap.put("paidAmt", "mstRpfPaid");
                     formMap.put("targetAmt", mstRpf - mstRpfPaid);
                     formMap.put("srvcContractID", 0);
                     formMap.put("billAsId", 0);
    				 formMap.put("srvMemId", 0);
//                     item. =  $("#rentalkeyInTrNo").val() ;
                     formMap.put("trNo", ""); //
//                     item. =  $("#rentalkeyInTrIssueDate").val() ;
                     formMap.put("trDt", ""); //
//                     item.collectorCode =  $("#rentalkeyInCollMemNm").val()
                     formMap.put("collectorCode", ""); //
//                     item.collectorId = $("#rentalkeyInCollMemId").val() ;
                     formMap.put("collectorId", "");
//                     item.allowComm = $("#rentalcashIsCommChk").val()
            		 formMap.put("allowComm", "1");

            		 formList.add(formMap);
            	}

            	int detailRowCnt = billInfoRentalList.size();

                for(j = 0 ; j < detailRowCnt ; j++){
                	Map billInfoRentalMap = billInfoRentalList.get(j);
//                    String detChkVal = (String) billInfoRentalMap.get("btnCheck");
                    String detSalesOrdNo = (String) billInfoRentalMap.get("ordNo");

                    if(salesOrdNo.equals(detSalesOrdNo)){
                    	formMap =  new HashMap<String, Object>();

                        formMap.put("procSeq", 1);
                        formMap.put("appType", "RENTAL");
                        formMap.put("advMonth",  (Integer)gridList.get("advMonth"));						// 셋팅필요
                        formMap.put("mstRpf", mstRpf);
                        formMap.put("mstRpfPaid", mstRpfPaid);

                        formMap.put("assignAmt",0);
                        formMap.put("billAmt", billInfoRentalMap.get("billAmt"));
                        formMap.put("billDt", billInfoRentalMap.get("billDt"));
                        formMap.put("billGrpId", billInfoRentalMap.get("billGrpId"));
                        formMap.put("billId", billInfoRentalMap.get("billId"));
                        formMap.put("billNo", billInfoRentalMap.get("billNo"));
                        formMap.put("billStatus", billInfoRentalMap.get("stusCode"));
                        formMap.put("billTypeId", billInfoRentalMap.get("billTypeId"));
                        formMap.put("billTypeNm", billInfoRentalMap.get("billTypeNm"));
                        formMap.put("custNm", billInfoRentalMap.get("custNm"));
                        formMap.put("discountAmt", 0);
                        formMap.put("installment", billInfoRentalMap.get("installment"));
                        formMap.put("ordId", billInfoRentalMap.get("ordId"));
                        formMap.put("ordNo", billInfoRentalMap.get("ordNo"));
                        formMap.put("paidAmt", billInfoRentalMap.get("paidAmt"));
                        formMap.put("appType",  "RENTAL");
                        formMap.put("targetAmt", billInfoRentalMap.get("targetAmt"));
                        formMap.put("srvcContractID", 0);
                        formMap.put("billAsId", 0);
						formMap.put("srvMemId", 0);

//	                     item. =  $("#rentalkeyInTrNo").val() ;
	                     formMap.put("trNo", ""); //
//	                     item. =  $("#rentalkeyInTrIssueDate").val() ;
	                     formMap.put("trDt", ""); //
//	                     item.collectorCode =  $("#rentalkeyInCollMemNm").val()
	                     formMap.put("collectorCode", ""); //
//	                     item.collectorId = $("#rentalkeyInCollMemId").val() ;
	                     formMap.put("collectorId", "");
//	                     item.allowComm = $("#rentalcashIsCommChk").val()
	            		 formMap.put("allowComm", "");

	            		 formList.add(formMap);
                    }
                }

                //Advance Month
//                System.out.println("++++ advMonth ::" + gridList.get("advMonth") );
//                if( StringUtils.isEmpty(gridList.get("advMonth"))  != "" && (Integer)gridList.get("advMonth") >= 0){
                if( !StringUtils.isEmpty(gridList.get("advMonth"))){
                	formMap =  new HashMap<String, Object>();

                    formMap.put("procSeq", 1);
                    formMap.put("appType", "RENTAL");
                    formMap.put("advMonth", (Integer)gridList.get("advMonth"));
                    formMap.put("mstRpf", mstRpf);
                    formMap.put("mstRpfPaid", mstRpfPaid);

                    formMap.put("assignAmt",0);
                    formMap.put("billAmt", (Double)gridList.get("advAmt") );
                    formMap.put("billDt",  "1900-01-01" );
                    formMap.put("billGrpId", mstCustBillId);
                    formMap.put("billId", 0);
                    formMap.put("billNo",  "0");
                    formMap.put("billStatus", "");
                    formMap.put("billTypeId", 1032);
                    formMap.put("billTypeNm", "General Advanced For Rental");
                    formMap.put("custNm", mstCustNm);
                    formMap.put("discountAmt", 0);
                    formMap.put("installment", 0);
                    formMap.put("ordId", salesOrdId);
                    formMap.put("ordNo", salesOrdNo);
                    formMap.put("paidAmt", 0 );
                    formMap.put("appType",  "RENTAL");
                    formMap.put("targetAmt",(Double)gridList.get("payAmt"));
                    formMap.put("srvcContractID", 0);
                    formMap.put("billAsId", 0);
					formMap.put("srvMemId", 0);

//                     item. =  $("#rentalkeyInTrNo").val() ;
                     formMap.put("trNo", ""); //
//                     item. =  $("#rentalkeyInTrIssueDate").val() ;
                     formMap.put("trDt", ""); //
//                     item.collectorCode =  $("#rentalkeyInCollMemNm").val()
                     formMap.put("collectorCode", ""); //
//                     item.collectorId = $("#rentalkeyInCollMemId").val() ;
                     formMap.put("collectorId", "");
//                     item.allowComm = $("#rentalcashIsCommChk").val()
            		 formMap.put("allowComm", "");

            		 formList.add(formMap);

               }
//            }
		}

    	// List 셋팅 종료
        // BankStatement 조회
//    	Map<String, Object> tmpKey = (Map<String, Object>) params.get("key"); //BankStatement의 id값 가져오기
    	String tmpKey =  (String) params.get("key"); //BankStatement의 id값 가져오기
    	int key = Integer.parseInt(String.valueOf(tmpKey));

        Map<String, Object> schParams = new HashMap<String, Object>();
        schParams.put("fTrnscId", key);
        EgovMap selectBankStatementInfo = mobilePaymentKeyInMapper.selectBankStatementInfo(schParams);

    	Map<String, Object> formInfo = new HashMap<String, Object> ();
    	if(gridFormList.size() > 0){
    		for(Object obj : gridFormList){
    			Map<String, Object> map = (Map<String, Object>) obj;
    			formInfo.put((String)map.get("name"), map.get("value"));
    		}
    	}

    	if(formInfo.get("chargeAmount") == null || formInfo.get("chargeAmount").equals("")){
    		formInfo.put("chargeAmount", 0);
    	}

    	if(formInfo.get("bankAcc") == null || formInfo.get("bankAcc").equals("")){
    		formInfo.put("bankAcc", 0);
    	}

		formInfo.put("payItemIsLock", false);
		formInfo.put("payItemIsThirdParty", false);
		formInfo.put("payItemStatusId", 1);
		formInfo.put("isFundTransfer", false);
		formInfo.put("skipRecon", false);
		formInfo.put("payItemCardTypeId", 0);

		formInfo.put("keyInPayRoute", "WEB");
		formInfo.put("keyInScrn", "NOR");
		formInfo.put("amount",  selectBankStatementInfo.get("crdit"));
		formInfo.put("slipNo", gridList.get("slipNo"));
		formInfo.put("bankType", "2729");
		formInfo.put("keyInPayDate", selectBankStatementInfo.get("trnscDt"));

		formInfo.put("bankAcc", selectBankStatementInfo.get("bankAccId"));
		formInfo.put("payType", "105");
		formInfo.put("trDate", gridList.get("trnscDt"));

		//User ID 세팅
    	gridList.put("userId", sUserId);
    	formInfo.put("userId", sUserId);
    	formInfo.put("userid", sUserId);

//    	System.out.println("++++ 3-1 formList.toString() ::" + formList.toString() );
//    	System.out.println("++++ 3 formInfo.toString() ::" + formInfo.toString() );
//		System.out.println("++++ 4 gridList.toString() ::" + gridList.toString() );
//		System.out.println("++++ 5 key ::" + key );

    	Map<String, Object> resultList = commonPaymentService.saveNormalPayment(formInfo, formList, key);

    	//=============================================================

    	// 상태 변경
    	mobilePaymentKeyInMapper.updateMobilePaymentKeyInUpdate(gridList);

        // 티겟 상태 변경
        Map<String, Object> ticketParam = new HashMap<String, Object>();
        ticketParam.put("ticketStusId", 5);
        ticketParam.put("updUserId", sUserId );
        ticketParam.put("mobTicketNo", gridList.get("mobTicketNo") );
        mobileAppTicketApiCommonMapper.update(ticketParam);

    	//WOR 번호 조회
    	return resultList;
    	//return rcList;
    }
}
