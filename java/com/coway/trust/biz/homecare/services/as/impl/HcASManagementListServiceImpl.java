package com.coway.trust.biz.homecare.services.as.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.services.as.HcASManagementListService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.as.impl.ASManagementListMapper;
import com.coway.trust.biz.services.as.impl.AsResultChargesViewVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 * -----------------------------------------------------------------------------
 * 11/12/2019    KR-JIN      1.0.0       - Restructure File
 *********************************************************************************************/

@Service("hcASManagementListService")
public class HcASManagementListServiceImpl extends EgovAbstractServiceImpl implements HcASManagementListService {

	private static final Logger LOGGER = LoggerFactory.getLogger(HcASManagementListServiceImpl.class);

	@Resource(name = "hcASManagementListMapper")
	private HcASManagementListMapper hcASManagementListMapper;

	//@Resource(name = "hcASManagementListService")
	//private HcASManagementListService hcASManagementListService;

	@Resource(name = "ASManagementListMapper")
	private ASManagementListMapper ASManagementListMapper;

	@Resource(name = "ASManagementListService")
	private ASManagementListService ASManagementListService;

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;

	//private HcASManagementListService hcASManagementListService;

	@Override
	public String getSearchDtRange() throws Exception{
		return hcASManagementListMapper.getSearchDtRange();
	}

	@Override
	public List<EgovMap> selectAsTyp() throws Exception{
		return hcASManagementListMapper.selectAsTyp();
	}

	@Override
	public List<EgovMap> selectAsStat() throws Exception{
		return hcASManagementListMapper.selectAsStat();
	}

	@Override
	public List<EgovMap> selectHomeCareBranchWithNm() throws Exception{
		return hcASManagementListMapper.selectHomeCareBranchWithNm();
	}

	@Override
	public List<EgovMap> selectCTByDSC(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.selectCTByDSC(params);
	}

	@Override
	public List<EgovMap> selectCTByDSCSearch(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.selectCTByDSCSearch(params);
	}

	@Override
	public List<EgovMap> selectCTByDSCSearch2(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.selectCTByDSCSearch2(params);
	}

/*	@Override
  public List<EgovMap> selectHTAndDTCode() throws Exception{
    return hcASManagementListMapper.selectHTAndDTCode();
  }*/

	@Override
	public List<EgovMap> getErrMstList(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getErrMstList(params);
	}

	@Override
	public List<EgovMap> selectASManagementList(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.selectASManagementList(params);
	}

	@Override
	public EgovMap selectOrderBasicInfo(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.selectOrderBasicInfo(params);
	}

	@Override
	public List<EgovMap> getASHistoryList(Map<String, Object> params) throws Exception{
	    return hcASManagementListMapper.getASHistoryList(params);
	}

	@Override
	public List<EgovMap> getBSHistoryList(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getBSHistoryList(params);
	}

	@Override
	public List<EgovMap> getBrnchId(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getBrnchId(params);
	}

	@Override
	public List<EgovMap> assignCtList(Map<String, Object> params) throws Exception{
		Map<String, Object> BrnchDet = new HashMap<String, Object>();
		BrnchDet = hcASManagementListMapper.selectBrnchType(params);
		params.put("brnchType", BrnchDet.get("code").toString());
	    return hcASManagementListMapper.assignCtList(params);
	}

	@Override
	public List<EgovMap> assignCtOrderList(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.assignCtOrderList(params);
	}

	@Override
	public List<EgovMap> getASFilterInfo(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getASFilterInfo(params);
	}
	@Override
	public List<EgovMap> getASFilterInfoOld(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getASFilterInfoOld(params);
	}

	@Override
	public List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getASRulstSVC0004DInfo(params);
	}

	@Override
	public List<EgovMap> getASRulstEditFilterInfo(Map<String, Object> params) throws Exception{
		return hcASManagementListMapper.getASRulstEditFilterInfo(params);
	}

    @Override
    public int updateAssignCT(Map<String, Object> params) throws Exception{
      List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
      int rtnValue = -1;

      if (updateItemList.size() > 0) {

        for (int i = 0; i < updateItemList.size(); i++) {
          Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
          updateMap.put("updator", params.get("updator"));
          rtnValue = hcASManagementListMapper.updateAssignCT(updateMap);
        }
      }
      return rtnValue;
    }

    @Override
    public List<EgovMap> selectLbrFeeChr(Map<String, Object> params) throws Exception{
    	return hcASManagementListMapper.selectLbrFeeChr(params);
    }

    // serial Y/N check
    @Override
    public String selectSerialYnSearch(Map<String, Object> params) throws Exception{
    	return hcASManagementListMapper.selectSerialYnSearch(params);
    }

   /* @Override
    public int hcChkRcdTms(Map<String, Object> params) throws Exception {
      return hcASManagementListMapper.hcChkRcdTms(params);
    }*/

    @Override
    public List<EgovMap> getPartnerMemInfo(Map<String, Object> params) throws Exception{
    	return hcASManagementListMapper.getPartnerMemInfo(params);
    }

    // as result pop save
    @Override
    public ReturnMessage newASInHouseAddSerial(Map<String, Object> params) throws Exception{

  	  ReturnMessage message = new ReturnMessage();

  	  HashMap<String, Object> mp = new HashMap<String, Object>();
  	  Map<?, ?> svc0004dmap = (Map<?, ?>) params.get("asResultM");
  	  mp.put("serviceNo", svc0004dmap.get("AS_NO"));

  	  params.put("asNo", svc0004dmap.get("AS_NO"));
  	  params.put("asEntryId", svc0004dmap.get("AS_ENTRY_ID"));
  	  params.put("asSoId", svc0004dmap.get("AS_SO_ID"));
  	  params.put("rcdTms", svc0004dmap.get("RCD_TMS"));
//  	  params.put("asCTId", svc0004dmap.get("AS_CT_ID"));
//  	  params.put("asBrnchId", svc0004dmap.get("AS_BRNCH_ID"));

  	  int noRcd = ASManagementListService.chkRcdTms(params);
      //int noRcd = hcASManagementListService.hcChkRcdTms(params);

  	  if (noRcd == 1) { // RECORD ABLE TO UPDATE
  	      int isAsCnt = ASManagementListService.isAsAlreadyResult(mp);
  	      LOGGER.debug("== isAsCnt " + isAsCnt);

  	      if (isAsCnt == 0) {
  	    	  EgovMap rtnValue = ASManagementListService.asResult_insert(params);
  	    	  if (null != rtnValue) {
  	    		  HashMap spMap = (HashMap) rtnValue.get("spMap");
  	    		  LOGGER.debug("spMap :" + spMap.toString());

  	    		  if (!spMap.isEmpty()) {
          	          if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
          	              rtnValue.put("logerr", "Y");
          	          }

          	          servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

          	          LOGGER.debug("SP_SVC_LOGISTIC_REQUEST_SERIAL===> " + spMap.toString());

          	          String errCode = (String)spMap.get("pErrcode");
                  	  String errMsg = (String)spMap.get("pErrmsg");

                  	  LOGGER.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR CODE : " + errCode);
                  	  LOGGER.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR MSG: " + errMsg);

                     	  // pErrcode : 000  = Success, others = Fail
                     	  if(!"000".equals(errCode)){
                     	    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
                     	  }
  	    		  }

      	          // ONGHC ADD FOR OPTIONAL FILTER
      	          boolean rst = ASManagementListService.insertOptFlt(params);

      	          if("Y".equals((String)svc0004dmap.get("SERIAL_REQUIRE_CHK_YN"))){
      	        	  // KR-OHK Barcode Save Start
      	        	  Map<String, Object> setmap = new HashMap();
      	        	  setmap.put("serialNo", svc0004dmap.get("SERIAL_NO"));
      	        	  setmap.put("salesOrdId", svc0004dmap.get("AS_SO_ID"));
      	        	  setmap.put("reqstNo", rtnValue.get("asNo"));
      	        	  setmap.put("callGbn", "AS");
      	        	  setmap.put("mobileYn", "N");
      	        	  setmap.put("userId", params.get("updator"));

      	        	  servicesLogisticsPFCService.SP_SVC_BARCODE_SAVE(setmap);

      	        	  String errCode = (String)setmap.get("pErrcode");
      	        	  String errMsg = (String)setmap.get("pErrmsg");

      	        	  LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS ERROR CODE : " + errCode);
      	        	  LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS ERROR MSG: " + errMsg);

      	        	  // pErrcode : 000  = Success, others = Fail
      	        	  if(!"000".equals(errCode)){
      	        		  throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
      	        	  }
      	        	  // KR-OHK Barcode Save Start
      	          }

  	    	  }

  	    	  message.setCode(AppConstants.SUCCESS);
      	      message.setData(rtnValue.get("asNo"));
      	      message.setMessage("");

      	  } else {
      		  message.setCode("98");
      	      message.setData(svc0004dmap.get("AS_NO"));
      	      message.setMessage("Result already exist with Complete Status.");
      	  }
  	  }  else {
  		  message.setMessage("Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
  		  message.setCode("99");
  	  }

  	  return message;
    }

    @Override
    public ReturnMessage newResultAdd(Map<String, Object> params) throws Exception{

    	LOGGER.debug("===========================/newResultAdd.do===============================");
    	LOGGER.debug("== params " + params.toString());

        LinkedHashMap asResultM = (LinkedHashMap) params.get("asResultM");
        List<EgovMap> add = (List<EgovMap>) params.get("add");
        List<EgovMap> remove = (List<EgovMap>) params.get("remove");
        List<EgovMap> update = (List<EgovMap>) params.get("update");

        LOGGER.debug("== asResultM = " + asResultM.toString());
        LOGGER.debug("== ADD = " + add.toString());
        LOGGER.debug("== REMOVE = " + remove.toString());
        LOGGER.debug("== UPDATE = " + update.toString());
        LOGGER.debug("===========================/newResultAdd.do===============================");

        ReturnMessage message = new ReturnMessage();

        HashMap mp = new HashMap();
        mp.put("serviceNo", asResultM.get("AS_NO"));
        int isAsCnt = ASManagementListService.isAsAlreadyResult(mp);

        if (isAsCnt == 0) {
          EgovMap rtnValue = ASManagementListService.asResult_insert(params);
          if (null != rtnValue) { // LOGISTIC STEP DONE
            HashMap spMap = (HashMap) rtnValue.get("spMap");
            LOGGER.debug("spMap :" + spMap.toString());
            if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
              rtnValue.put("logerr", "Y");
            }
            servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
          }
          message.setCode(AppConstants.SUCCESS);
          message.setData(rtnValue.get("AS_NO"));
          message.setMessage("");

        } else {
          message.setCode("98");
          message.setData(asResultM.get("AS_NO"));
          message.setMessage("Result already exist with Complete status.");
        }
        return message;
    }

    @Override
    public EgovMap asResult_updateSerial(Map<String, Object> params) throws Exception{

    	// AS'S EDIT RESULT
        ArrayList<AsResultChargesViewVO> vewList = null;
        List<EgovMap> addItemList = null;
        List<EgovMap> resultMList = null;

        LinkedHashMap svc0004dmap = null;
        EgovMap seqpay17Map = null;
        EgovMap eASEntryDocNo = null;
        EgovMap asResultASEntryId = null;
        EgovMap invoiceDocNo = null;

        String ACC_INV_VOID_ID = null;
        String NEW_AS_RESULT_ID = null;
        String NEW_AS_RESULT_NO = null;

        double asTotAmt = 0;

        svc0004dmap = (LinkedHashMap) params.get("asResultM");

        String AS_ID = String.valueOf(svc0004dmap.get("AS_ID"));
        String ACC_BILL_ID = String.valueOf(svc0004dmap.get("ACC_BILL_ID"));
        String ACC_INVOICE_NO = String.valueOf(svc0004dmap.get("ACC_INVOICE_NO")) != "" ? String.valueOf(svc0004dmap.get("ACC_INVOICE_NO")) : String.valueOf(svc0004dmap.get("AS_RESULT_NO"));
        params.put("ACC_BILL_ID", ACC_BILL_ID);
        params.put("ACC_INVOICE_NO", ACC_INVOICE_NO);

        seqpay17Map = ASManagementListMapper.getPAY0017SEQ(params);
        ACC_INV_VOID_ID = String.valueOf(seqpay17Map.get("seq"));
        params.put("ACC_INV_VOID_ID", ACC_INV_VOID_ID);

        params.put("DOCNO", "21");
        eASEntryDocNo = ASManagementListService.getASEntryDocNo(params);
        asResultASEntryId = ASManagementListService.getResultASEntryId(params);

        NEW_AS_RESULT_ID = String.valueOf(asResultASEntryId.get("seq"));
        NEW_AS_RESULT_NO = String.valueOf(eASEntryDocNo.get("asno"));

        svc0004dmap.put("NEW_AS_RESULT_ID", NEW_AS_RESULT_ID);
        svc0004dmap.put("NEW_AS_RESULT_NO", NEW_AS_RESULT_NO);
        svc0004dmap.put("updator", params.get("updator"));

        vewList = new ArrayList<AsResultChargesViewVO>();
        addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);

        // GET LATEST SVC0004D RECORD
        resultMList = ASManagementListMapper.getResult_SVC0004D(svc0004dmap);

        EgovMap emp = (EgovMap) resultMList.get(0);
        svc0004dmap.put("AS_RESULT_ID", String.valueOf(emp.get("asResultId")));
        svc0004dmap.put("AS_RESULT_NO", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
        asTotAmt = Double.parseDouble(String.valueOf(((EgovMap) resultMList.get(0)).get("asTotAmt")));

        LOGGER.debug("== OLD SVC0004D'S RECORD : " + resultMList.toString());
        LOGGER.debug("== OLD TOTAL AMOUNT : " + asTotAmt);

        // KR-OHK Barcode Save Start
        if("Y".equals((String)svc0004dmap.get("SERIAL_REQUIRE_CHK_YN"))){
            Map<String, Object> setmapRev = new HashMap();
            setmapRev.put("serialNo", svc0004dmap.get("SERIAL_NO"));
            setmapRev.put("salesOrdId", svc0004dmap.get("AS_SO_ID"));
            setmapRev.put("reqstNo", svc0004dmap.get("AS_RESULT_NO"));
            setmapRev.put("callGbn", "AS_REVERSE");
            setmapRev.put("mobileYn", "N");
            setmapRev.put("userId", params.get("updator"));

            servicesLogisticsPFCService.SP_SVC_BARCODE_SAVE(setmapRev);

            String errCodeRev = (String)setmapRev.get("pErrcode");
        	String errMsgRev = (String)setmapRev.get("pErrmsg");

        	LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS_REVERSE ERROR CODE : " + errCodeRev);
        	LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS_REVERSE ERROR MSG: " + errMsgRev);

        	// pErrcode : 000  = Success, others = Fail
        	if(!"000".equals(errCodeRev)){
        		throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCodeRev + ":" + errMsgRev);
        	}
        }
    	// KR-OHK Barcode Save Start

        // REVERSE SVC0004D
        svc0004dmap.put("OLD_AS_RESULT_ID", svc0004dmap.get("AS_RESULT_ID"));
        int reverse_SVC0004D_cnt = ASManagementListMapper.reverse_SVC0004D(svc0004dmap); // INSERT REVERSE SVC0004D
        int reverse_CURR_SVC0004D_cnt = ASManagementListMapper.reverse_CURR_SVC0004D(svc0004dmap); // UPDATE OLD ISCUR COLUMN TO 0 MAKE IT NOT THE LATEST RECORD
        int reverse_SVC0005D_cnt = ASManagementListMapper.reverse_CURR_SVC0005D(svc0004dmap); // INSERT REVERSE SVC0005D
        // INSERT REVERSE USED FILTER
        int reverse_LOG0103M_cnt = ASManagementListMapper.reverse_CURR_LOG0103M(svc0004dmap); // INSERT REVERSE SVC0005D

        // REVERSE LOGISTIC CALL
        Map<String, Object> logPram = null;
        logPram = new HashMap<String, Object>();
        logPram.put("ORD_ID", NEW_AS_RESULT_ID);
        logPram.put("RETYPE", "RETYPE");
        logPram.put("P_TYPE", "OD04");
        logPram.put("P_PRGNM", "ASCEN");
        logPram.put("USERID", String.valueOf(svc0004dmap.get("updator")));

        Map SRMap = new HashMap();
        servicesLogisticsPFCService.SP_LOGISTIC_REQUEST_REVERSE_SERIAL(logPram);
        LOGGER.debug("== RESULT CALL SP_LOGISTIC_REQUEST_REVERSE_SERIAL : " + logPram.toString());


        // 테스트용
        int abc = ASManagementListMapper.selectTestChk(svc0004dmap);
        LOGGER.debug("######" + abc );

        if(!"000".equals(logPram.get("p1"))) {
    	    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + logPram.get("p1")+ ":" + "AS EDIT Result Error");
    	}

        // ADD NEW AS RESULT
        EgovMap cm = ASManagementListMapper.getLog0016DCount(svc0004dmap);
        int log0016dCnt = Integer.parseInt(String.valueOf(cm.get("cnt")));

        // AUTO REQUEST PDO (IF CURRENT RESULT HAS COMPLETE PDO CLAIM)
        if (log0016dCnt > 0) {
          LOGGER.debug("== START REQUEST PDO - START ==");
          EgovMap PDO_DocNoMap = null;
          EgovMap LOG_IDMap = null;
          String PDO_DocNo = null;
          String LOG16_ID = null;

          params.put("DOCNO", "26");
          PDO_DocNoMap = ASManagementListService.getASEntryDocNo(params);
          PDO_DocNo = String.valueOf(PDO_DocNoMap.get("asno"));

          LOG_IDMap = ASManagementListMapper.getLOG0015DSEQ(params);
          LOG16_ID = String.valueOf(LOG_IDMap.get("seq"));

          svc0004dmap.put("STK_REQ_ID", LOG16_ID);
          svc0004dmap.put("STK_REQ_NO", PDO_DocNo);

          int a = ASManagementListMapper.insert_LOG0015D(svc0004dmap);
          if (a > 0) {
            int insert_LOG0016D_cnt = ASManagementListMapper.insert_LOG0016D(svc0004dmap);
          }
          LOGGER.debug("== START REQUEST PDO - END ==");
        }

        // Reverse InvStkRecordCard (Return Stock To Member's Hand) -- Prepare for
        // PDO return (ACF)
        // ~~~~~~~~~~~~~ 수정필요 SEELECT 후 INSERT 처리 하자. ......
        // ASManagementListMapper.insert_LOG0014D(svc0004dmap); 꼭 주석 ㅜ

        // CN Waive Billing (If Current Result has charge)
        if (asTotAmt > 0) {
        	ASManagementListMapper.reverse_PAY0007D(svc0004dmap);

          svc0004dmap.put("ACC_BILL_ID", svc0004dmap.get("ACC_BILL_ID"));
          List<EgovMap> resultPAY0016DList = ASManagementListMapper.getResult_SVC0004D(svc0004dmap);

          EgovMap pay0016dData = null;
          if (null != resultPAY0016DList) {
            int reverse_updatePAY0016D_cnt = ASManagementListMapper.reverse_updatePAY0016D(svc0004dmap);
          }

          pay0016dData = (EgovMap) ASManagementListMapper.getResult_PAY0016D(svc0004dmap);

          EgovMap CN_DocNoMap = null;
          String CNNO = null;

          EgovMap CNReportNo_DocNoMap = null;
          String CNReportNo = null;

          params.put("DOCNO", "134");
          CN_DocNoMap = ASManagementListService.getASEntryDocNo(params);
          CNNO = String.valueOf(CN_DocNoMap.get("asno"));

          params.put("DOCNO", "18");
          CNReportNo_DocNoMap = ASManagementListService.getASEntryDocNo(params);
          CNReportNo = String.valueOf(CNReportNo_DocNoMap.get("asno"));

          List<EgovMap> resultPAY0031DList = null;
          svc0004dmap.put("accBillRem", pay0016dData.get("accBillRem"));
          resultPAY0031DList = ASManagementListMapper.getResult_PAY0031D(svc0004dmap);
          EgovMap resultPAY0031DInfo = resultPAY0031DList.get(0);

          ////////////////// pay16d AccOrderBill ////////////////////
          EgovMap PAY0016DSEQMap = ASManagementListMapper.getPAY0016DSEQ(params);
          String PAY0016DSEQ = String.valueOf(PAY0016DSEQMap.get("seq"));
          EgovMap pay16d_insert = new EgovMap();
          pay16d_insert.put("memoAdjId", PAY0016DSEQ);
          pay16d_insert.put("memoAdjRefNo", CNNO);
          pay16d_insert.put("memoAdjRptNo", CNReportNo);
          pay16d_insert.put("memoAdjTypeId", "1293");
          pay16d_insert.put("memoAdjInvcNo", pay0016dData.get("accBillRem"));
          pay16d_insert.put("memoAdjInvcTypeId", "128");
          pay16d_insert.put("memoAdjStusId", "4");
          pay16d_insert.put("memoAdjResnId", "2038");
          pay16d_insert.put("memoAdjRem", "AS RESULT REVERSAL_" + resultPAY0031DInfo.get("taxInvcSvcNo"));
          pay16d_insert.put("memoAdjTxsAmt", resultPAY0031DInfo.get("taxInvcTxs"));
          pay16d_insert.put("memoAdjTotAmt", resultPAY0031DInfo.get("taxInvcAmtDue"));
          pay16d_insert.put("memoAdjCrtDt", new Date());
          pay16d_insert.put("memoAdjCrtUserId", svc0004dmap.get("updator"));
          pay16d_insert.put("memoAdjUpdDt", new Date());
          pay16d_insert.put("memoAdjUpdUserId", svc0004dmap.get("updator"));
          pay16d_insert.put("batchId", "");
          ASManagementListMapper.reverse_PAY0016D(pay16d_insert);
          ////////////////// ////////////////////

          ////////////////// AccInvoiceAdjustment_Sub ////////////////////
          svc0004dmap.put("MEMO_ADJ_ID", PAY0016DSEQ);
          svc0004dmap.put("MEMO_ITM_TAX_CODE_ID", pay0016dData.get("accBillTaxCodeId"));
          svc0004dmap.put("MEMO_ITM_REM", "AS RESULT REVERSAL_" + resultPAY0031DInfo.get("taxInvcSvcNo"));
          svc0004dmap.put("TAX_INVC_REF_NO", pay0016dData.get("accBillRem"));
          int reverse_PAY0012D_cnt = ASManagementListMapper.reverse_PAY0012D(svc0004dmap);
          ////////////////// pay12d ////////////////////

          ////////////////// pay27d AccTaxDebitCreditNote ////////////////////
          EgovMap PAY0027DSEQMap = ASManagementListMapper.getPAY0027DSEQ(params);
          String PAY0027DSEQ = String.valueOf(PAY0027DSEQMap.get("seq"));
          EgovMap pay27d_insert = new EgovMap();
          pay27d_insert.put("noteId", PAY0027DSEQ);
          pay27d_insert.put("noteEntryId", PAY0016DSEQ);
          pay27d_insert.put("noteTypeId", "1293");
          pay27d_insert.put("noteGrpNo", resultPAY0031DInfo.get("taxInvcSvcNo"));
          pay27d_insert.put("noteRefNo", CNNO);
          pay27d_insert.put("noteRefDt", resultPAY0031DInfo.get("taxInvcRefDt"));
          pay27d_insert.put("noteInvcNo", pay0016dData.get("accBillRem"));
          pay27d_insert.put("noteInvcTypeId", "128");
          pay27d_insert.put("noteCustName", resultPAY0031DInfo.get("taxInvcCustName"));
          pay27d_insert.put("noteCntcPerson", resultPAY0031DInfo.get("taxInvcCntcPerson"));
          pay27d_insert.put("noteAddr1", resultPAY0031DInfo.get("taxInvcAddr1"));
          pay27d_insert.put("noteAddr2", resultPAY0031DInfo.get("taxInvcAddr2"));
          pay27d_insert.put("noteAddr3", resultPAY0031DInfo.get("taxInvcAddr3"));
          pay27d_insert.put("noteAddr4", resultPAY0031DInfo.get("taxInvcAddr4"));
          pay27d_insert.put("notePostCode", resultPAY0031DInfo.get("taxInvcPostCode"));
          pay27d_insert.put("noteAreaName", "");
          pay27d_insert.put("noteStateName", resultPAY0031DInfo.get("taxInvcStateName"));
          pay27d_insert.put("noteCntyName", resultPAY0031DInfo.get("taxInvcCnty"));
          pay27d_insert.put("noteTxs", resultPAY0031DInfo.get("taxInvcTxs"));
          pay27d_insert.put("noteChrg", resultPAY0031DInfo.get("taxInvcChrg"));
          pay27d_insert.put("noteAmtDue", resultPAY0031DInfo.get("taxInvcAmtDue"));
          pay27d_insert.put("noteRem", "AS RESULT REVERSAL - " + resultPAY0031DInfo.get("taxInvcSvcNo"));
          pay27d_insert.put("noteStusId", "4");
          pay27d_insert.put("noteCrtDt", new Date());
          pay27d_insert.put("noteCrtUserId", svc0004dmap.get("updator"));
          ASManagementListMapper.reverse_PAY0027D(pay27d_insert);
          ////////////////// pay27d end ////////////////////

          ////////// AccTaxDebitCreditNote_Sub ////////////
          if (reverse_PAY0012D_cnt > 0) {
            svc0004dmap.put("NOTE_ID", PAY0027DSEQ);
            int reverse_PAY0028D_cnt = ASManagementListMapper.reverse_PAY0028D(svc0004dmap);
          }

          ////////////////// pay17d pay18d ////////////////////
          EgovMap PAY0017DSEQMap = ASManagementListMapper.getPAY0017DSEQ(params);
          String PAY0017DSEQ = String.valueOf(PAY0017DSEQMap.get("seq"));
          svc0004dmap.put("ACC_INV_VOID_ID", PAY0017DSEQ);
          svc0004dmap.put("accInvVoidSubCrditNoteId", PAY0016DSEQ);
          svc0004dmap.put("accInvVoidSubCrditNote", CNNO);
          ASManagementListService.setPay17dData(svc0004dmap);
          ASManagementListService.setPay18dData(svc0004dmap);
          ////////////////// pay17d pay18d end////////////////////

          ////////////////// pay06d ////////////////////
          EgovMap pay06d_insert = new EgovMap();
          pay06d_insert.put("asId", AS_ID);
          pay06d_insert.put("asDocNo", CNNO);
          pay06d_insert.put("asLgDocTypeId", "155");
          pay06d_insert.put("asLgDt", new Date());
          pay06d_insert.put("asLgAmt", (-1 * asTotAmt));
          pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
          pay06d_insert.put("asLgUpdDt", new Date());
          pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
          pay06d_insert.put("asResultNo", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
          pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
          pay06d_insert.put("asAdvPay", "0");
          pay06d_insert.put("r01", "");
          // 4
          int reverse_PAY0006D_cnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
          ////////////////// pay06d end////////////////////
        }

        ////////////////// pay06d ////////////////////
        /// Restore Advanced AS Payment Use In Current Result
        List<EgovMap> p6dList = ASManagementListMapper.getResult_PAY0006D(svc0004dmap);
        if (null != p6dList && p6dList.size() > 0) {
          for (int i = 0; i < p6dList.size(); i++) {
            EgovMap pay06d_insert = p6dList.get(i);

            ////////////////// pay06d 1set ////////////////////
            BigDecimal asLgAmt = (BigDecimal) pay06d_insert.get("asLgAmt");
            // double p16d_asTotAmt = pay06d_insert.get("asLgAmt") ==null ? 0 :
            // Double.parseDouble((String)pay06d_insert.get("asLgAmt") );
            long p16d_asTotAmt = pay06d_insert.get("asLgAmt") == null ? 0 : asLgAmt.longValue();

            pay06d_insert.put("asId", AS_ID);
            pay06d_insert.put("asDocNo", NEW_AS_RESULT_NO);
            pay06d_insert.put("asLgDocTypeId", "163");
            pay06d_insert.put("asLgDt", new Date());
            pay06d_insert.put("asLgAmt", (-1 * p16d_asTotAmt));
            pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
            pay06d_insert.put("asLgUpdDt", new Date());
            pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
            pay06d_insert.put("asResultNo", (String) ((EgovMap) resultMList.get(0)).get("asResultNo"));
            pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
            pay06d_insert.put("asAdvPay", "1");
            pay06d_insert.put("r01", "");
            // 3
            int reverse_PAY0006D_1setCnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
            ////////////////// pay06d 1set end////////////////

            ////////////////// pay06d 2set ////////////////////
            pay06d_insert.put("asId", AS_ID);
            pay06d_insert.put("asDocNo", NEW_AS_RESULT_NO);
            pay06d_insert.put("asLgDocTypeId", "401");
            pay06d_insert.put("asLgDt", new Date());
            pay06d_insert.put("asLgAmt", (-1 * p16d_asTotAmt));
            pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
            pay06d_insert.put("asLgUpdDt", new Date());
            pay06d_insert.put("asSoNo", svc0004dmap.get("AS_SO_NO"));
            pay06d_insert.put("asResultNo", "");
            pay06d_insert.put("asSoId", svc0004dmap.get("AS_SO_ID"));
            pay06d_insert.put("asAdvPay", "1");
            pay06d_insert.put("r01", "");
            // 2
            int reverse_PAY0006D_2setCnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
            ////////////////// pay06d 2set end////////////////
          }
        }
        ////////////////// pay06d end ////////////////////

        // Reverse All AS Payment Transaction Including Reverse Payment,because
        // reverse payment can be partial amount
        List<EgovMap> p7dList = ASManagementListMapper.getResult_PAY0007D(svc0004dmap);
        if (null != p7dList && p7dList.size() > 0) {

          ////////////////// pay07d update ////////////////
          int reverse_StateUpPAY0007D_cnt = ASManagementListMapper.reverse_StateUpPAY0007D(svc0004dmap);
          ////////////////// pay07d update ////////////////

          ////////////////// PAY0064D SELECT ////////////////

          svc0004dmap.put("BILL_ID", String.valueOf((p7dList.get(0)).get("billId")));
          List<EgovMap> p64dList = ASManagementListMapper.getResult_PAY0064D(svc0004dmap);
          ////////////////// PAY0064D ////////////////
          if (null != p64dList && p64dList.size() > 0) {
            for (int i = 0; i < p64dList.size(); i++) {

              EgovMap p64dList_Map = p64dList.get(i);
              BigDecimal totAmt = (BigDecimal) p64dList_Map.get("totAmt");
              // double trxTotAmt = p64dList_Map.get("totAmt") ==null ? 0 :
              // Double.parseDouble((String)p64dList_Map.get("totAmt") );
              long trxTotAmt = p64dList_Map.get("totAmt") == null ? 0 : totAmt.longValue();
              Map PAY_DocNoMap = null;
              String PAYNO_REV = null;

              params.put("DOCNO", "82");
              PAY_DocNoMap = ASManagementListMapper.getASEntryDocNo(params);
              PAYNO_REV = String.valueOf(PAY_DocNoMap.get("asno"));

              EgovMap PAY0069DSEQMap = ASManagementListMapper.getPAY0069DSEQ(params);
              String PAY0069DSEQ = String.valueOf(PAY0069DSEQMap.get("seq"));

              ////////////////// PAY0069D insert ////////////////
              EgovMap pay069d_insert = new EgovMap();
              pay069d_insert.put("trxId", PAY0069DSEQ);
              pay069d_insert.put("trxDt", new Date());
              pay069d_insert.put("trxType", "101");
              pay069d_insert.put("trxAmt", (-1 * trxTotAmt));
              pay069d_insert.put("trxMtchNo", "");

              int insert_PAY0069D_cnt = ASManagementListMapper.insert_PAY0069D(pay069d_insert);
              ////////////////// PAY0069D out ////////////////

              ////////////////// PAY0064D insert ////////////////
              EgovMap PAY0064DSEQMap = ASManagementListMapper.getPAY0064DSEQ(params);
              String PAY0064DSEQ = String.valueOf(PAY0064DSEQMap.get("seq"));

              EgovMap pay064d_insert = new EgovMap();
              pay064d_insert.put("payId", PAY0064DSEQ);
              pay064d_insert.put("orNo", PAYNO_REV);
              pay064d_insert.put("salesOrdId", p64dList_Map.get("salesOrdId"));
              pay064d_insert.put("billId", p64dList_Map.get("billId"));
              pay064d_insert.put("trNo", p64dList_Map.get("trNo"));
              pay064d_insert.put("typeId", "101");
              // pay064d_insert.put("payData",new Date());
              pay064d_insert.put("bankChgAmt", p64dList_Map.get("bankChgAmt"));
              pay064d_insert.put("bankChgAccId", p64dList_Map.get("bankChgAccId"));
              pay064d_insert.put("collMemId", p64dList_Map.get("collMemId"));
              pay064d_insert.put("brnchId", params.get("brnchId"));
              pay064d_insert.put("bankAccId", p64dList_Map.get("bankAccId"));
              pay064d_insert.put("allowComm", p64dList_Map.get("allowComm"));
              pay064d_insert.put("stusCodeId", "1");
              pay064d_insert.put("updUserId", svc0004dmap.get("updator"));
              // pay064d_insert.put("updDt",new Date());
              pay064d_insert.put("syncHeck", "0");
              pay064d_insert.put("custId3party", p64dList_Map.get("custId3party"));
              // double p46TotAmt = p64dList_Map.get("totAmt") ==null ? 0 :
              // Double.parseDouble((String)p64dList_Map.get("totAmt") );
              pay064d_insert.put("totAmt", (-1 * trxTotAmt)); // p46TotAmt
              pay064d_insert.put("mtchId", p64dList_Map.get("payId"));
              pay064d_insert.put("crtUserId", svc0004dmap.get("updator"));
              // pay064d_insert.put("crtDt",new Date());
              pay064d_insert.put("isAllowRevMulti", "0");
              pay064d_insert.put("isGlPostClm", "0");
              pay064d_insert.put("glPostClmDt", "01/01/1900");
              pay064d_insert.put("trxId", PAY0069DSEQ);
              pay064d_insert.put("advMonth", "0");
              pay064d_insert.put("accBillId", "0");
              pay064d_insert.put("trIssuDt", "01/01/1900");
              pay064d_insert.put("taxInvcIsGen", "0");
              pay064d_insert.put("taxInvcRefNo", "");
              pay064d_insert.put("taxInvcRefDt", "01/01/1900");
              pay064d_insert.put("svcCntrctId", "0");
              pay064d_insert.put("batchPayId", "0");
              int insert_PAY0064D_cnt = ASManagementListMapper.insert_PAY0064D(pay064d_insert);
              ////////////////// PAY0064D out ////////////////

              ////////////////// PAY0065D insert ////////////////
              svc0004dmap.put("PAY_ID", PAY0064DSEQ);
              List<EgovMap> p65dList = ASManagementListMapper.getResult_PAY0065D(svc0004dmap);
              EgovMap PAY0065DSEQMap = ASManagementListMapper.getPAY0065DSEQ(params);
              String PAY0065DSEQ = String.valueOf(PAY0065DSEQMap.get("seq"));

              if (null != p65dList && p65dList.size() > 0) {
                for (int a = 0; a < p65dList.size(); a++) {

                  // INSER PAY0065D
                  EgovMap p65dList_Map = p65dList.get(i);
                  // double payTotAmt = p65dList_Map.get("payItmAmt") ==null ? 0 :
                  // Double.parseDouble(((String)p65dList_Map.get("payItmAmt") ));

                  BigDecimal totAmt65D = (BigDecimal) p65dList_Map.get("totAmt");
                  long trxTotAmt65D = p65dList_Map.get("totAmt") == null ? 0 : totAmt65D.longValue();

                  EgovMap pay065d_insert = new EgovMap();
                  pay065d_insert.put("payItmId", PAY0065DSEQ);
                  pay065d_insert.put("payId", PAY0064DSEQ);
                  pay065d_insert.put("payItmModeId", p65dList_Map.get("payItmModeId"));
                  pay065d_insert.put("payItmRefNo", p65dList_Map.get("payItmRefNo"));
                  pay065d_insert.put("payItmCcNo", p65dList_Map.get("payItmCcNo"));
                  pay065d_insert.put("payItmOriCcNo", p65dList_Map.get("payItmOriCcNo"));
                  pay065d_insert.put("payItmEncryptCcNo", p65dList_Map.get("payItmEncryptCcNo"));
                  pay065d_insert.put("payItmCcTypeId", p65dList_Map.get("payItmCcTypeId"));
                  pay065d_insert.put("payItmChqNo", p65dList_Map.get("payItmChqNo"));
                  pay065d_insert.put("payItmIssuBankId", p65dList_Map.get("payItmIssuBankId"));
                  pay065d_insert.put("payItmAmt", (-1 * trxTotAmt65D)); // payTotAmt
                  pay065d_insert.put("payItmIsOnline", p65dList_Map.get("payItmIssuBankId"));
                  pay065d_insert.put("payItmBankAccId", p65dList_Map.get("payItmIssuBankId"));
                  pay065d_insert.put("payItmRefDt", "01/01/1900");
                  pay065d_insert.put("payItmAppvNo", p65dList_Map.get("payItmIssuBankId"));
                  pay065d_insert.put("payItmRem", "AS RESULT EDIT (REVERSE PAYMENT)");
                  pay065d_insert.put("payItmStusId", "1");
                  pay065d_insert.put("payItmIsLok", "0");
                  pay065d_insert.put("payItmCcHolderName", p65dList_Map.get("payItmCcHolderName"));
                  pay065d_insert.put("payItmCcExprDt", p65dList_Map.get("payItmCcExprDt"));
                  pay065d_insert.put("payItmBankChrgAmt", p65dList_Map.get("payItmBankChrgAmt"));
                  pay065d_insert.put("payItmIsThrdParty", p65dList_Map.get("payItmIsThrdParty"));
                  pay065d_insert.put("payItmThrdPartyIc", p65dList_Map.get("payItmThrdPartyIc"));
                  pay065d_insert.put("payItmRefItmId", p65dList_Map.get("payItmId"));
                  pay065d_insert.put("skipRecon", "0");

                  pay065d_insert.put("payItmBankBrnchId", "0");
                  pay065d_insert.put("payItmBankInSlipNo", "0");
                  pay065d_insert.put("payItmEftNo", "0");
                  pay065d_insert.put("payItmChqDepReciptNo", "0");
                  pay065d_insert.put("etc1", "0");
                  pay065d_insert.put("etc2", "0");
                  pay065d_insert.put("etc3", "0");
                  pay065d_insert.put("payItmGrpId", "0");
                  pay065d_insert.put("payItmBankChrgAccId", "0");
                  pay065d_insert.put("updUserId", "0");
                  pay065d_insert.put("updDt", "");
                  pay065d_insert.put("isFundTrnsfr", "0");
                  pay065d_insert.put("payItmCardTypeId", "0");
                  pay065d_insert.put("payItmCardModeId", "0");
                  pay065d_insert.put("payItmRunngNo", "");
                  pay065d_insert.put("payItmMid", "");

                  int insert_PAY0065D_cnt = ASManagementListMapper.insert_PAY0065D(pay065d_insert);

                  // INSERT PAY0009D
                  EgovMap pay09d_insert = new EgovMap();
                  pay09d_insert.put("glPostngDt", new Date());
                  pay09d_insert.put("glFiscalDt", "01/01/1900");
                  pay09d_insert.put("glBatchNo", PAY0064DSEQ);
                  pay09d_insert.put("glBatchTypeDesc", "");
                  pay09d_insert.put("glBatchTot", (-1 * trxTotAmt65D));
                  pay09d_insert.put("glReciptNo", PAYNO_REV);
                  pay09d_insert.put("glReciptTypeId", "101");
                  pay09d_insert.put("glReciptBrnchId", svc0004dmap.get("brnchId"));

                  if ("107".equals(p65dList_Map.get("payItmModeId"))) { // ConvertTempAccountToSettlementAccount
                    int t_payItmIssuBankId = p65dList_Map.get("payItmIssuBankId") == null ? 0
                        : Integer.parseInt((String) p65dList_Map.get("payItmIssuBankId"));
                    pay09d_insert.put("glReciptSetlAccId", ASManagementListService.convertTempAccountToSettlementAccount(t_payItmIssuBankId));
                    pay09d_insert.put("glReciptAccId", p65dList_Map.get("payItmIssuBankId"));

                  } else {
                    int t_payItmModeId = p65dList_Map.get("payItmModeId") == null ? 0
                        : Integer.parseInt((String) p65dList_Map.get("payItmModeId"));
                    pay09d_insert.put("glReciptAccId", ASManagementListService.convertAccountToTempBasedOnPayMode(t_payItmModeId)); // ConvertAccountToTempBasedOnPayMode
                    pay09d_insert.put("glReciptSetlAccId", "0");
                  }

                  pay09d_insert.put("glReciptItmId", PAY0065DSEQ);
                  pay09d_insert.put("glReciptItmModeId", p65dList_Map.get("payItmModeId"));
                  pay09d_insert.put("glRevrsReciptItmId", p65dList_Map.get("payItmId"));
                  pay09d_insert.put("glReciptItmAmt", (-1 * trxTotAmt65D));

                  double t_payItemBankChargeAmt = p65dList_Map.get("payItmBankChrgAmt") == null ? 0
                      : Double.parseDouble(((String) p65dList_Map.get("payItmBankChrgAmt")));
                  pay09d_insert.put("glReciptItmChrg", t_payItemBankChargeAmt);
                  pay09d_insert.put("glReciptItmRclStus", "N");
                  pay09d_insert.put("glJrnlNo", "");
                  pay09d_insert.put("glAuditRef", "");
                  pay09d_insert.put("glCnvrStus", "Y");
                  pay09d_insert.put("glCnvrDt", "");
                  int insert_PAY0009D_cnt = ASManagementListMapper.insert_PAY0009D(pay09d_insert);
                }
              }

              // INSERT PAY0006D
              svc0004dmap.put("AS_DOC_NO", String.valueOf(p64dList_Map.get("orNo")));
              List<EgovMap> p06dList = ASManagementListMapper.getResult_DocNo_PAY0006D(svc0004dmap);

              if (null != p06dList && p06dList.size() > 0) {
                for (int a = 0; a < p06dList.size(); a++) {

                  EgovMap p06dList_Map = p06dList.get(i);
                  // double asLgAmt = p06dList_Map.get("asLgAmt") ==null ? 0 :
                  // Double.parseDouble(((String)p06dList_Map.get("asLgAmt") ));

                  BigDecimal totAmt06D = (BigDecimal) p06dList_Map.get("totAmt");
                  long trxTotAmt06D = p06dList_Map.get("totAmt") == null ? 0 : totAmt06D.longValue();

                  EgovMap pay06d_insert = new EgovMap();

                  pay06d_insert.put("asId", AS_ID);
                  pay06d_insert.put("asDocNo", PAYNO_REV);
                  pay06d_insert.put("asLgDocTypeId", "160");
                  pay06d_insert.put("asLgDt", new Date());
                  pay06d_insert.put("asLgAmt", (trxTotAmt06D * -1)); // asLgAmt
                  pay06d_insert.put("asLgUpdUserId", svc0004dmap.get("updator"));
                  pay06d_insert.put("asLgUpdDt", new Date());
                  pay06d_insert.put("asSoNo", p06dList_Map.get("asSoNo"));
                  pay06d_insert.put("asResultNo", p06dList_Map.get("asSoNo"));
                  pay06d_insert.put("asSoId", p06dList_Map.get("asSoId"));
                  pay06d_insert.put("asAdvPay", p06dList_Map.get("asAdvPay"));
                  pay06d_insert.put("r01", "");
                  // 1
                  int reverse_PAY0006D_cnt = ASManagementListMapper.reverse_DocNo_PAY0006D(pay06d_insert);

                }
              }
            }
          }
        }


        // 테스트용
        int abcd = ASManagementListMapper.selectTestChk(svc0004dmap);
        LOGGER.debug("######" + abcd );

        // REVERSE HAPPY CALL
        svc0004dmap.put("HC_TYPE_NO", svc0004dmap.get("AS_NO"));
        int reverse_State_CCR0001D_cnt = ASManagementListMapper.reverse_State_CCR0001D(svc0004dmap);

        // UNMAP PAYMENT
        if (ASManagementListMapper.chkPmtMap(svc0004dmap) >= 1) {
          LOGGER.debug(" =================== START TO UNMAP PAYMENT =================== ");
          // PAYMENT HAD MAPPED.
          // INSERT BACKUP
          LOGGER.debug(" =================== 1. BACKUP =================== ");
          ASManagementListMapper.bckupPAY0252T(svc0004dmap);
          // REMOVE DATA
          LOGGER.debug(" =================== 2. REMOVE =================== ");
          //ASManagementListMapper.rmvPAY0252T(svc0004dmap);
          // UPDATE STATUS
          LOGGER.debug(" =================== 3. UPDATE =================== ");
          ASManagementListMapper.updPAY0081D(svc0004dmap);
          LOGGER.debug(" =================== END TO UNMAP PAYMENT =================== ");
        }

        // REINSERT
        ((Map) params.get("asResultM")).put("AUTOINSERT", "TRUE");// hash
        EgovMap returnemp = ASManagementListService.asResult_insert(params);
        returnemp.put("NEW_AS_RESULT_NO", NEW_AS_RESULT_NO);

        boolean rst = ASManagementListService.insertOptFlt(params);

        // KR-OHK Barcode Save Start
        if("Y".equals((String)svc0004dmap.get("SERIAL_REQUIRE_CHK_YN"))){
            Map<String, Object> setmapEdit = new HashMap();
            setmapEdit.put("serialNo", svc0004dmap.get("SERIAL_NO"));
            setmapEdit.put("salesOrdId", svc0004dmap.get("AS_SO_ID"));
            setmapEdit.put("reqstNo", svc0004dmap.get("AS_RESULT_NO"));
            setmapEdit.put("callGbn", "AS_EDIT");
            setmapEdit.put("mobileYn", "N");
            setmapEdit.put("userId", params.get("updator"));

            servicesLogisticsPFCService.SP_SVC_BARCODE_SAVE(setmapEdit);

            String errCodeEdit = (String)setmapEdit.get("pErrcode");
        	String errMsgEdit = (String)setmapEdit.get("pErrmsg");

        	LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS_EDIT ERROR CODE : " + errCodeEdit);
        	LOGGER.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE AS_EDIT ERROR MSG: " + errMsgEdit);

        	// pErrcode : 000  = Success, others = Fail
        	if(!"000".equals(errCodeEdit)){
        		throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCodeEdit + ":" + errMsgEdit);
        	}
        }
    	// KR-OHK Barcode Save Start
        return returnemp;
    }

    @Override
    public List<EgovMap> getAsDefectEntry(Map<String, Object> params) {
      return hcASManagementListMapper.getAsDefectEntry(params);
    }

    @Override
    public List<EgovMap> getErrDetilList(Map<String, Object> params) {
      return hcASManagementListMapper.getErrDetilList(params);
    }

}