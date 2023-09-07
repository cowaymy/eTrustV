package com.coway.trust.biz.sales.pos.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.biz.sales.pos.vo.PosDetailVO;
import com.coway.trust.biz.sales.pos.vo.PosGridVO;
import com.coway.trust.biz.sales.pos.vo.PosLoyaltyRewardVO;
import com.coway.trust.biz.sales.pos.vo.PosMasterVO;
import com.coway.trust.biz.sales.pos.vo.PosMemberVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.math.BigDecimal;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("posService")
public class PosServiceImpl extends EgovAbstractServiceImpl implements PosService {

  private static final Logger LOGGER = LoggerFactory.getLogger(PosServiceImpl.class);

  @Resource(name = "posMapper")
  private PosMapper posMapper;

  @Resource(name = "posStockMapper")
  private PosStockMapper posStockMapper;


  @Override
  public List<EgovMap> selectPosModuleCodeList(Map<String, Object> params) throws Exception {

    return posMapper.selectPosModuleCodeList(params);
  }

  @Override
  public List<EgovMap> selectStatusCodeList(Map<String, Object> params) throws Exception {

    return posMapper.selectStatusCodeList(params);
  }

  @Override
  public List<EgovMap> selectPosJsonList(Map<String, Object> params) throws Exception {

    return posMapper.selectPosJsonList(params);
  }

  @Override
  public List<EgovMap> selectWhBrnchList() throws Exception {

    return posMapper.selectWhBrnchList();
  }

  @Override
  public EgovMap selectWarehouse(Map<String, Object> params) throws Exception {

    return posMapper.selectWarehouse(params);
  }

  @Override
  public List<EgovMap> selectPosTypeList(Map<String, Object> params) throws Exception {

    return posMapper.selectPosTypeList(params);
  }

  /*
   * @Override public List<EgovMap> selectPIItmTypeList() throws Exception {
   *
   * return posMapper.selectPIItmTypeList(); }
   */

  /*
   * @Override public List<EgovMap> selectPIItmList(Map<String, Object> params)
   * throws Exception {
   *
   * return posMapper.selectPIItmList(params); }
   */

  @Override
  public List<EgovMap> selectPosItmList(Map<String, Object> params) throws Exception {

    return posMapper.selectPosItmList(params);
  }

  @Override
  public List<EgovMap> chkStockList(Map<String, Object> params) throws Exception {

    List<EgovMap> retunList = null;

    retunList = posMapper.chkStockList(params);

    return retunList;
  }

  @Override
  public List<EgovMap> chkStockList2(Map<String, Object> params) throws Exception {

    List<EgovMap> retunList = null;

    retunList = posMapper.chkStockList2(params);

    return retunList;
  }

  @Override
  public EgovMap getMemCode(Map<String, Object> params) throws Exception {

    return posMapper.getMemCode(params);
  }

  @Override
  public List<EgovMap> getReasonCodeList(Map<String, Object> params) throws Exception {

    return posMapper.getReasonCodeList(params);
  }

  @Override
  public List<EgovMap> getFilterSerialNum(Map<String, Object> params) throws Exception {

    List<EgovMap> serialList = null;

    // KR-OHK Serial Check add
    if ("Y".equals(params.get("serialRequireChkYn"))) {
      serialList = posMapper.getFilterSerialNumLOG0100(params);
    } else {
      serialList = posMapper.getFilterSerialNum(params);
    }
    return serialList;
  }

  @Override
  public List<EgovMap> getConfirmFilterListAjax(Map<String, Object> params) throws Exception {

    List<EgovMap> serialList = null;

    // KR-OHK Serial Check add
    if ("Y".equals(params.get("serialRequireChkYn"))) {
      serialList = posMapper.getFilterSerialNumLOG0100(params);
    } else {
      serialList = posMapper.getFilterSerialNum(params);
    }

    return serialList;
  }

  @Override
  public Map<String, Object> insertPos(Map<String, Object> params) throws Exception {

    String docNoPsn = ""; // returnValue
    String docNoInvoice = "";
    LOGGER.info("############### get Params  ################");
    /* ############### get Params ################ */
    // Form
    Map<String, Object> posMap = (Map<String, Object>) params.get("form");
    // Grid1
    List<Object> basketGrid = (List<Object>) params.get("prch");
    // Grid2
    List<Object> serialGrid = (List<Object>) params.get("serial");
    // Grid3
    List<Object> memGird = (List<Object>) params.get("mem");
    // Grid4
    List<Object> payGrid = (List<Object>) params.get("pay");
    // pay Form
    Map<String, Object> payFormMap = (Map<String, Object>) params.get("payform");

    LOGGER.info("############### get DOC Number & Sequence & full Name & Amounts  ################");
    /*
     * ############## get DOC Number & Sequence & full Name & Amounts
     * ###########
     */
    params.put("docNoId", SalesConstants.POS_DOC_NO_PSN_NO);
    docNoPsn = posMapper.getDocNo(params); //////////////////////// PSN (144)
    params.put("docNoId", SalesConstants.POS_DOC_NO_INVOICE_NO);
    docNoInvoice = posMapper.getDocNo(params); //////////////////// INVOICE
                                               //////////////////// (143)

    LOGGER.info("################################## docNoPsn : " + docNoPsn);
    LOGGER.info("################################## docNoInvoice : " + docNoInvoice);

    EgovMap nameMAp = null;
    nameMAp = posMapper.getUserFullName(posMap);

    BigDecimal tempTotalAmt = new BigDecimal("0");
    BigDecimal tempTotalTax = new BigDecimal("0");
    ;
    BigDecimal tempTotalCharge = new BigDecimal("0");
    ;
    BigDecimal tempTotalDiscount = new BigDecimal("0");

    BigDecimal calHundred = new BigDecimal("100");
    BigDecimal calGst = new BigDecimal(SalesConstants.POS_INV_ITM_GST_RATE);
    BigDecimal tempCal = calHundred.add(calGst);

    // BigDecimal deducSize = new BigDecimal(basketGrid.size()); // Deduction
    // Size
    LOGGER.info("########################## tempCal : " + tempCal);
    for (int i = 0; i < basketGrid.size(); i++) {
      Map<String, Object> amtMap = null;

      amtMap = (Map<String, Object>) basketGrid.get(i);
      BigDecimal tempQty = new BigDecimal(String.valueOf(amtMap.get("inputQty")));
      BigDecimal tempUnitPrc = new BigDecimal(String.valueOf(amtMap.get("amt")));
      BigDecimal tempDiscount = new BigDecimal(String.valueOf(amtMap.get("totalDiscount") == null ? 0 : amtMap.get("totalDiscount")));

      BigDecimal tempCurAmt = tempUnitPrc.multiply(tempQty); // Prc * Qty
      BigDecimal tempCurCharge = tempCurAmt; // Charges
      BigDecimal tempCurTax = tempCurAmt.subtract(tempCurCharge); // Tax

      LOGGER.info("__________________________________________________________________________________________");
      LOGGER.info("_____________NO.[" + i + "] =  prc : " + tempUnitPrc + ",  qty : " + tempQty + " , total Amt : "
          + tempCurAmt + " , total Tax : " + tempCurTax + " , total Charges : " + tempCurCharge + " , total Discount : " + tempDiscount);
      LOGGER.info("__________________________________________________________________________________________");

      tempTotalAmt = tempTotalAmt.add(tempCurAmt);
      tempTotalTax = tempTotalTax.add(tempCurTax);
      tempTotalCharge = tempTotalCharge.add(tempCurCharge);
      tempTotalDiscount = tempTotalDiscount.add(tempDiscount);

    }

    double rtnAmt = tempTotalAmt.doubleValue();
    double rtnTax = tempTotalTax.doubleValue();
    double rtnCharge = tempTotalCharge.doubleValue();
    double rtnDiscount = tempTotalDiscount.doubleValue();
    rtnAmt = rtnAmt - rtnDiscount;

    if ((SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION)
        .equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2391

      /*
       * rtnAmt = rtnAmt *memGird.size(); rtnTax = rtnTax*memGird.size();
       * rtnCharge = rtnCharge*memGird.size();
       */

    }

    LOGGER.info("_____________________________________________________________________________________");
    LOGGER.info("_______________________ TOTAL PRICE : " + rtnAmt + " , TOTAL TAX : " + rtnTax + " , TOTAL CHARGES : "
        + rtnCharge + ", TOTAL DISCOUNT : " + rtnDiscount + " ");
    LOGGER.info("_____________________________________________________________________________________");



    LOGGER.info("############### Parameter Setting , Insert and Update  ################");
    /* #### Parameter Setting , Insert and Update ###### */

    // 1.
    // *********************************************************************************************************
    // POS MASTER
    // Seq
    int posMasterSeq = posMapper.getSeqSal0057D(); // master Sequence

    // DRAccId , CRAccId Setting
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)) { // 1352
                                                                                                       // //filter
                                                                                                       // with
                                                                                                       // payment

      posMap.put("drAccId", SalesConstants.POS_DRACC_ID_FILTER); // 540 //122111
      posMap.put("crAccId", SalesConstants.POS_CRACC_ID_FILTER); // 541 //414002
    }
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK)) { // 1353
                                                                                                        // //itembank
                                                                                                        // with
                                                                                                        // payment

      posMap.put("drAccId", SalesConstants.POS_DRACC_ID_ITEMBANK); // 540
                                                                   // //122111
      posMap.put("crAccId", SalesConstants.POS_CRACC_ID_ITEMBANK); // 549
                                                                   // //601510
    }
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)
        || String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK_HQ)) { // 1357
                                                                                                              // or
                                                                                                              // 1358
      // TODO ASIS 기준으로는 하나의 아이템 타입만 구입할 수있었으니 지금은 여러가지 타입의 아이템을 구할수 있으므로 해당 로직
      // 사용 불가함 //임의 수치 부여
      // EgovMap accCodeMap = null;
      // accCodeMap = posMapper.getItemBankAccCodeByItemTypeID(posMap);
      posMap.put("drAccId", SalesConstants.POS_DRACC_ID_OTH);
      posMap.put("crAccId", SalesConstants.POS_CRACC_ID_OTH);

    }

    posMap.put("posMasterSeq", posMasterSeq); // posId = 0 -- 시퀀스
    posMap.put("docNoPsn", docNoPsn); // posNo = 0 --문서채번
    posMap.put("posBillId", SalesConstants.POS_BILL_ID); // pos Bill Id // 0

    EgovMap memCodeMap = null;
    memCodeMap = posMapper.selectMemberByMemberIDCode(params);

    // TODO Other Income 만 사용?? Branch 없음 임시 번호 부여
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)) { // 1357
                                                                                                             // Other
                                                                                                             // Income

      posMap.put("othCheck", SalesConstants.POS_OTH_CHECK_PARAM); // OTH Check
      posMap.put("posCustName", posMap.get("insPosCustName")); // posCustName =
                                                               // other Income만
                                                               // 사용함 .. 그러면
                                                               // 나머지는??
      params.put("memCode", params.get("userName"));
      /*
       * EgovMap memCodeMap = null; memCodeMap =
       * posMapper.selectMemberByMemberIDCode(params);
       */

      // TODO IVYLIM is NULL
      if (memCodeMap != null) {
        posMap.put("salesmanPopId", memCodeMap.get("memId"));
      } else {
        posMap.put("salesmanPopId", "0");
      }

    } else {
      posMap.put("posCustName", nameMAp.get("name")); // posCustName = other
                                                      // Income만 사용함 .. 그러면
                                                      // 나머지는??
    }
    posMap.put("posTotalAmt", rtnAmt);
    posMap.put("posCharge", rtnCharge);
    posMap.put("posTaxes", rtnTax);
    posMap.put("posDiscount", rtnDiscount); // TODO 확인 필요
    // hidLocId 와 branch ID
    if (posMap.get("hidLocId") == null) {
      posMap.put("hidLocId", "0");
    }
    posMap.put("posMtchId", 0);
    posMap.put("posCustomerId", SalesConstants.POS_CUST_ID); // 107205
    posMap.put("userId", params.get("userId"));

    /*
     * if(params.get("userDeptId") == null){ params.put("userDeptId", 0); }
     */
    posMap.put("userDeptId", 0);
    if (params.get("userDeptId") == null) {
      params.put("userDeptCode", " ");
    }
    posMap.put("userDeptCode", params.get("userDeptId"));

    // Status Setting
    if ((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2390
                                                                                                                   // //
                                                                                                                   // POS-TYPE
                                                                                                                   // :
                                                                                                                   // POS
                                                                                                                   // SALES

      if (String.valueOf(posMap.get("payResult")).equals("1")) { ////////////////////////////////////////////////////////////////////////////////////////// 1.
                                                                 ////////////////////////////////////////////////////////////////////////////////////////// WITH
                                                                 ////////////////////////////////////////////////////////////////////////////////////////// PAYMENT
        posMap.put("posStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); // STUS_ID
                                                                              // ==
                                                                              // Non
                                                                              // Receive
      } else { //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 2.
               //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// WITHOUT
               //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// PAYMENT
        posMap.put("posStusId", SalesConstants.POS_SALES_STATUS_ACTIVE); // STUS_ID
                                                                         // ==
                                                                         // Active
      }
    }

    if ((SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION)
        .equals(String.valueOf(posMap.get("insPosModuleType"))) || //// 2391
                                                                   //// //POS
                                                                   //// TYPE :
                                                                   //// DEDUCTION
                                                                   //// COMMISSION
                                                                   //// - NO
                                                                   //// PAYMENT
        (SalesConstants.POS_SALES_MODULE_TYPE_OTH).equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2392
                                                                                                             // //POS
                                                                                                             // TYPE
                                                                                                             // :
                                                                                                             // OTHER
      posMap.put("posStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); // STUS_ID
                                                                            // ==
                                                                            // Non
                                                                            // Receive
    }

    // POS TYPE : OTHER INCOME - NO PAYMENT
    /*
     * if("OHTER INCOME 일때"){ posMap.put("posStusId",
     * SalesConstants.POS_SALES_STATUS_NON_RECEIVE); //STUS_ID == Non Receive }
     */

    posMap.put("userId", params.get("userId"));

    if (posMap.get("posReason") == null || String.valueOf(posMap.get("posReason")).equals("")) {
      posMap.put("posReason", "0");
    }

    // Pos Master Insert
    LOGGER.info("############### 1. POS MASTER INSERT START  ################");
    LOGGER.info("############### 1. POS MASTER INSERT param : " + posMap.toString());
    posMapper.insertPosMaster(posMap);
    LOGGER.info("############### 1. POS MASTER INSERT END  ################");
    // 2.
    // *********************************************************************************************************
    // POS DETAIL

    // Grid to Map Params
    // 1). POST TYPE : POS_SALES
    LOGGER.info("************************************* POSMAP`s Params : " + posMap.toString());
    LOGGER.info(
        "************************************* POSMAP - type  : " + String.valueOf(posMap.get("insPosModuleType")));
    LOGGER.info("************************************* POSMAP - constans(pos_sales)  : "
        + SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES);
    LOGGER.info("************************************* POSMAP - constans(deduction_commission)  : "
        + SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION);

    if ((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf(posMap.get("insPosModuleType"))) // 2390
        || (SalesConstants.POS_SALES_MODULE_TYPE_OTH).equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2392
      for (int idx = 0; idx < basketGrid.size(); idx++) { // basket Grid
        Map<String, Object> itemMap = (Map<String, Object>) basketGrid.get(idx);

        int posDetailSeq = posMapper.getSeqSal0058D(); // detail Sequence
        itemMap.put("posDetailSeq", posDetailSeq);
        itemMap.put("posMasterSeq", posMasterSeq);
        itemMap.put("posItemTaxCodeId", SalesConstants.POS_ITM_TAX_CODE_ID); // 32
        itemMap.put("posMemId", posMap.get("salesmanPopId")); // MEM_ID
        itemMap.put("posRcvStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); // RCV_STUS_ID
                                                                                  // 96
                                                                                  // ==
                                                                                  // nonReceive
        itemMap.put("userId", params.get("userId"));
        LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT START  ################");
        LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT param : " + itemMap.toString());
        posMapper.insertPosDetail(itemMap);
        LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT END  ################");

        System.out.println("----------------------------");
        System.out.println(posMap);
        System.out.println("----------------------------");

      } // Detail Insert End

      if(posMap.get("hidLrpId") != null){
        posMapper.updateLoyaltyRewardPoint(posMap);
      }

      // Serial Insert
      if (serialGrid != null) {
        for (int i = 0; i < serialGrid.size(); i++) {
          Map<String, Object> serialMap = (Map<String, Object>) serialGrid.get(i);
          int serialSeq = posMapper.getSeqSal0147M();

          serialMap.put("serialSeq", serialSeq);
          serialMap.put("posMasterSeq", posMasterSeq);
          serialMap.put("userId", params.get("userId"));
          // TODO ITEM Status ID?
          // serialMap.put("posItmStusId", 1);

          LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT START  ################");
          LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT param : " + serialMap.toString());
          posMapper.insertSerialNo(serialMap);
          LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT END  ################");

        }
      }
    }
    // 2). POST TYPE : DEDUCTION COMMISSION //2391
    if ((SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION)
        .equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2391
      for (int idx = 0; idx < basketGrid.size(); idx++) { // basket Grid

        Map<String, Object> deducItemMap = (Map<String, Object>) basketGrid.get(idx); // item
                                                                                      // Map

        LOGGER
            .info("############### 2 - Member(Item) - [" + idx + "]  POS DETAIL(Member) MAP SETTING  ################");
        // for (int i = 0; i < memGird.size(); i++) {
        // Map<String, Object> memMap = (Map<String, Object>)memGird.get(i);
        // //item List
        Map<String, Object> memMap = new HashMap<String, Object>();
        int posDetailDuducSeq = posMapper.getSeqSal0058D(); // detail Sequence
        memMap.put("posDetailDuducSeq", posDetailDuducSeq);
        memMap.put("posMasterSeq", posMasterSeq);
        memMap.put("posDetailStkId", deducItemMap.get("stkId")); // POS_ITM_STOCK_ID
        memMap.put("posDetailQty", deducItemMap.get("inputQty")); // POS_ITM_QTY
        memMap.put("posDetailUnitPrc", deducItemMap.get("amt")); // Price
        memMap.put("posDetailTotal", deducItemMap.get("totalAmt")); // ToTal
        memMap.put("posDetailCharge", deducItemMap.get("subTotal")); // Charge
        memMap.put("posDetailTaxs", deducItemMap.get("subChng")); // Tax
        memMap.put("posItemTaxCodeId", SalesConstants.POS_ITM_TAX_CODE_ID); // 32
        memMap.put("posRcvStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); // RCV_STUS_ID
                                                                                 // 96
                                                                                 // ==
                                                                                 // nonReceive
        memMap.put("memId", posMap.get("salesmanPopId"));
        memMap.put("memCode", posMap.get("salesmanPopCd"));
        memMap.put("memType", memCodeMap.get("memType"));
        memMap.put("name", posMap.get("posCustName"));
        memMap.put("fullName", posMap.get("posCustName"));
        memMap.put("nric", memCodeMap.get("nric"));
        memMap.put("stus", memCodeMap.get("stus"));
        memMap.put("userId", params.get("userId"));

        // LOGGER.info("############### 2 - Member(Item ["+idx+"]) - MemLoop ["
        // + i + "] POS DETAIL(Member) INSERT START ################");
        // LOGGER.info("############### 2 - Member(Item ["+idx+"]) - MemLoop ["
        // + i + "] POS DETAIL(Member) INSERT param : " + memMap.toString());
        posMapper.insertDeductionPosDetail(memMap);
        // LOGGER.info("############### 2 - Member(Item ["+idx+"]) - MemLoop ["
        // + i + "] POS DETAIL(Member) INSERT END ################");
        // }
        LOGGER.info(
            "############### 2 - Member(Item) - [" + idx + "]  POS DETAIL(Member) MAP SETTING END  ################");

      }
    }

    // 3.
    // *********************************************************************************************************
    // ACC BILLING
    Map<String, Object> accBillingMap = new HashMap<String, Object>();
    int posBillSeq = posMapper.getSeqPay0007D();
    accBillingMap.put("posBillSeq", posBillSeq); // accbilling.BillID = 0;
    accBillingMap.put("posBillTypeId", SalesConstants.POS_BILL_TYPE_ID); // accbilling.BillTypeID
                                                                         // =
                                                                         // 569;
    accBillingMap.put("posBillSoId", 0); // accbilling.BillSOID = 0;
    accBillingMap.put("posBillMemId", posMap.get("salesmanPopId")); // accbilling.BillMemID
                                                                    // = 0;
    accBillingMap.put("posBillAsId", 0); // accbilling.BillASID = 0;
    accBillingMap.put("posBillPayTypeId", 0); // accbilling.BillPayTypeID = 0;
    accBillingMap.put("docNoPsn", docNoPsn); // accbilling.BillNo = ""; //update
                                             // later //POS RefNo.
    accBillingMap.put("posMemberShipNo", ""); // accbilling.BillMemberShipNo =
                                              // "";
    accBillingMap.put("posBillAmt", rtnAmt); // accbilling.BillAmt =
                                             // Convert.ToDouble(totalcharges);
    accBillingMap.put("posBillRem", posMap.get("posRemark")); // accbilling.BillRemark
                                                              // =
                                                              // this.txtRemark.Text.Trim();
    accBillingMap.put("posBillIsPaid", 1); // accbilling.BillIsPaid = true;
    accBillingMap.put("posBillIsComm", 0); // accbilling.BillIsComm = false;
    accBillingMap.put("userId", params.get("userId"));
    accBillingMap.put("posSyncChk", 1); // accbilling.SyncCheck = true;
    accBillingMap.put("posCourseId", 0); // accbilling.CourseID = 0;
    accBillingMap.put("posStatusId", 1);// accbilling.StatusID = 1;
    LOGGER.info("############### 3. POS ACC BILLING INSERT START  ################");
    LOGGER.info("############### 3. POS ACC BILLING INSERT param : " + accBillingMap.toString());
    posMapper.insertPosBilling(accBillingMap);
    LOGGER.info("############### 3. POS ACC BILLING INSERT END  ################");

    // 4.
    // *********************************************************************************************************
    // POS MASTER UPDATE BILL_ID
    Map<String, Object> posUpMap = new HashMap<String, Object>();
    posUpMap.put("posBillSeq", posBillSeq);
    posUpMap.put("posMasterSeq", posMasterSeq);
    LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE START  ################");
    LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE param : " + posUpMap.toString());
    posMapper.updatePosMasterPosBillId(posUpMap);
    LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE END  ################");

    // 5.
    // *********************************************************************************************************
    // ACC ORDER BILL

    // 3. ACCORDERBILLING
    Map<String, Object> accOrdBillingMap = new HashMap<String, Object>();
    int accOrderBillSeq = posMapper.getSeqPay0016D();

    accOrdBillingMap.put("posOrderBillSeq", accOrderBillSeq); // accorderbill.AccBillID
                                                              // = 0;
    accOrdBillingMap.put("posOrdBillTaskId", 0); // accorderbill.AccBillTaskID =
                                                 // 0;
    accOrdBillingMap.put("posOrdBillRefNo", "1000"); // accorderbill.AccBillRefNo
                                                     // = "1000"; //update later
                                                     // //at db
    accOrdBillingMap.put("posOrdBillOrdId", 0); // accorderbill.AccBillOrderID =
                                                // 0;
    accOrdBillingMap.put("posOrdBillOrdNo", ""); // accorderbill.AccBillOrderNo
                                                 // = "";
    accOrdBillingMap.put("posOrdBillTypeId", SalesConstants.POS_ORD_BILL_TYPE_ID); // accorderbill.AccBillTypeID
                                                                                   // =
                                                                                   // 1159;
                                                                                   // //System
                                                                                   // Generate
                                                                                   // Bill
    accOrdBillingMap.put("posOrdBillModeId", SalesConstants.POS_ORD_BILL_MODE_ID); // accorderbill.AccBillModeID
                                                                                   // =
                                                                                   // 1351;
                                                                                   // //SOI
                                                                                   // Bill
                                                                                   // (POS
                                                                                   // New
                                                                                   // Version)
    accOrdBillingMap.put("posOrdBillScheduleId", 0); // accorderbill.AccBillScheduleID
                                                     // = 0;
    accOrdBillingMap.put("posOrdBillSchedulePeriod", 0); // accorderbill.AccBillSchedulePeriod
                                                         // = 0;
    accOrdBillingMap.put("posOrdBillAdjustmentId", 0); // accorderbill.AccBillAdjustmentID
                                                       // = 0;
    accOrdBillingMap.put("posOrdBillScheduleAmt", rtnAmt); // accorderbill.AccBillScheduleAmount
                                                           // =
                                                           // decimal.Parse(totalcharges);
    accOrdBillingMap.put("posOrdBillAdjustmentAmt", 0); // accorderbill.AccBillAdjustmentAmount
                                                        // = 0;
    accOrdBillingMap.put("posOrdBillTaxesAmt", rtnTax); // accorderbill.AccBillTaxesAmount
                                                        // =
                                                        // Convert.ToDecimal(string.Format("{0:0.00}",
                                                        // decimal.Parse(totalcharges)
                                                        // -
                                                        // (System.Convert.ToDecimal(totalcharges)
                                                        // * 100 / 106)));
    accOrdBillingMap.put("posOrdBillNetAmount", rtnAmt); // accorderbill.AccBillNetAmount
                                                         // =
                                                         // decimal.Parse(totalcharges);
    accOrdBillingMap.put("posOrdBillStatus", 1); // accorderbill.AccBillStatus =
                                                 // 1;
    accOrdBillingMap.put("posOrdBillRem", docNoInvoice); // accorderbill.AccBillRemark
                                                         // = ""; //Invoice No.
    accOrdBillingMap.put("userId", params.get("userId"));
    accOrdBillingMap.put("posOrdBillGroupId", 0); // accorderbill.AccBillGroupID
                                                  // = 0;
    accOrdBillingMap.put("posOrdBillTaxCodeId", SalesConstants.POS_ORD_BILL_TAX_CODE_ID); // accorderbill.AccBillTaxCodeID
                                                                                          // =
                                                                                          // 32;
    accOrdBillingMap.put("posOrdBillTaxRate", 0); // accorderbill.AccBillTaxRate
                                                  // = 6;
    accOrdBillingMap.put("posOrdBillAcctCnvr", 0); // TODO ASIS 소스 없음
    accOrdBillingMap.put("posOrdBillCntrctId", 0); // TODO ASIS 소스 없음

    LOGGER.info("############### 5. POS ACC ORDER BILL INSERT START  ################");
    LOGGER.info("############### 5. POS ACC ORDER BILL INSERT param : " + accOrdBillingMap.toString());
    posMapper.insertPosOrderBilling(accOrdBillingMap);
    LOGGER.info("############### 5. POS ACC ORDER BILL INSERT END  ################");

    // 6.
    // *********************************************************************************************************
    // ACC TAX INVOICE MISCELLANEOUS

    Map<String, Object> accTaxInvoiceMiscellaneouMap = new HashMap<String, Object>();
    int accTaxInvMiscSeq = posMapper.getSeqPay0031D();

    accTaxInvoiceMiscellaneouMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq); // InvMiscMaster.TaxInvoiceID
                                                                            // =
                                                                            // 0;
    accTaxInvoiceMiscellaneouMap.put("posTaxInvRefNo", docNoInvoice); // InvMiscMaster.TaxInvoiceRefNo
                                                                      // = "";
                                                                      // //update
                                                                      // later
    accTaxInvoiceMiscellaneouMap.put("posTaxInvSvcNo", docNoPsn); // InvMiscMaster.TaxInvoiceServiceNo
                                                                  // = ""; //SOI
                                                                  // No.
    accTaxInvoiceMiscellaneouMap.put("posTaxInvType", SalesConstants.POS_TAX_INVOICE_TYPE); // InvMiscMaster.TaxInvoiceType
                                                                                            // =
                                                                                            // 142;
                                                                                            // //pos
                                                                                            // new
                                                                                            // version

    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)) { // 1357
                                                                                                             // Other
                                                                                                             // Income
      accTaxInvoiceMiscellaneouMap.put("posTaxInvCustName", posMap.get("insPosCustName")); // InvMiscMaster.TaxInvoiceCustName
                                                                                           // =
                                                                                           // this.txtCustName.Text.Trim();
      accTaxInvoiceMiscellaneouMap.put("posTaxInvCntcPerson", posMap.get("insPosCustName")); // InvMiscMaster.TaxInvoiceContactPerson
                                                                                             // =
                                                                                             // this.txtCustName.Text.Trim();

    } else {
      accTaxInvoiceMiscellaneouMap.put("posTaxInvCustName", nameMAp.get("name")); // InvMiscMaster.TaxInvoiceCustName
                                                                                  // =
                                                                                  // this.txtCustName.Text.Trim();
      accTaxInvoiceMiscellaneouMap.put("posTaxInvCntcPerson", nameMAp.get("name")); // InvMiscMaster.TaxInvoiceContactPerson
                                                                                    // =
                                                                                    // this.txtCustName.Text.Trim();
    }
    accTaxInvoiceMiscellaneouMap.put("posTaxInvTaskId", 0); // InvMiscMaster.TaxInvoiceTaskID
                                                            // = 0;
    accTaxInvoiceMiscellaneouMap.put("posTaxInvUserName", params.get("userName")); // InvMiscMaster.TaxInvoiceRemark
                                                                                   // =
                                                                                   // li.LoginID;
    accTaxInvoiceMiscellaneouMap.put("posTaxInvCharges", rtnCharge); // InvMiscMaster.TaxInvoiceCharges
                                                                     // =
                                                                     // Convert.ToDecimal(string.Format("{0:0.00}",
                                                                     // (decimal.Parse(totalcharges)
                                                                     // * 100 /
                                                                     // 106)));
    accTaxInvoiceMiscellaneouMap.put("posTaxInvTaxes", rtnTax); // InvMiscMaster.TaxInvoiceTaxes
                                                                // =
                                                                // Convert.ToDecimal(string.Format("{0:0.00}",
                                                                // decimal.Parse(totalcharges)
                                                                // -
                                                                // (decimal.Parse(totalcharges)
                                                                // * 100 /
                                                                // 106)));
    accTaxInvoiceMiscellaneouMap.put("posTaxInvTotalCharges", rtnAmt); // InvMiscMaster.TaxInvoiceAmountDue
                                                                       // =
                                                                       // decimal.Parse(totalcharges);
    accTaxInvoiceMiscellaneouMap.put("userId", params.get("userId"));

    // TODO 추후 삭제
    /* Magic Address 미구현 추후 삭제 */
    /*
     * accTaxInvoiceMiscellaneouMap.put("addr1", "");
     * accTaxInvoiceMiscellaneouMap.put("addr2", "");
     * accTaxInvoiceMiscellaneouMap.put("addr3", "");
     * accTaxInvoiceMiscellaneouMap.put("addr4", "");
     * accTaxInvoiceMiscellaneouMap.put("postCode", "");
     * accTaxInvoiceMiscellaneouMap.put("stateName", "");
     * accTaxInvoiceMiscellaneouMap.put("cnty", "");
     */

    LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS INSERT START  ################");
    LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS INSERT param : "
        + accTaxInvoiceMiscellaneouMap.toString());
    posMapper.insertPosTaxInvcMisc(accTaxInvoiceMiscellaneouMap);
    LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS END  ################");
    // 7.
    // *********************************************************************************************************
    // ACC TAX INVOICE MISCELLANEOUS_SUB
    int invItemTypeID = 0;

    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)) { // filter
                                                                                                       // 1352
      invItemTypeID = 1355;
    }
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK)) { // item
                                                                                                        // bank
                                                                                                        // 1353
      invItemTypeID = 1356;
    }
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)) { // other
                                                                                                             // income
      invItemTypeID = 1359;
    }
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK_HQ)) { // item
                                                                                                           // bank-HQ
      invItemTypeID = 1360;
    }
    for (int idx = 0; idx < basketGrid.size(); idx++) {
      Map<String, Object> invDetailMap = new HashMap<String, Object>();
      invDetailMap = (Map<String, Object>) basketGrid.get(idx);
      int invDetailSeq = posMapper.getSeqPay0032D();

      invDetailMap.put("invDetailSeq", invDetailSeq); // InvMiscD.InvocieItemID
                                                      // = 0;
      invDetailMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq); // InvMiscD.TaxInvoiceID
                                                              // = 0; //update
                                                              // later
      invDetailMap.put("invItemTypeID", invItemTypeID); // InvMiscD.InvoiceItemType
                                                        // = invItemTypeID;
      invDetailMap.put("posTaxInvSubOrdNo", ""); // InvMiscD.InvoiceItemOrderNo
                                                 // = "";
      invDetailMap.put("posTaxInvSubItmPoNo", ""); // InvMiscD.InvoiceItemPONo =
                                                   // "";
      // InvMiscD.InvoiceItemCode =
      // itm.GetDataKeyValue("ItemStkCode").ToString();
      // InvMiscD.InvoiceItemDescription1 =
      // itm.GetDataKeyValue("ItemStkDesc").ToString();
      invDetailMap.put("posTaxInvSubDescSub", ""); // InvMiscD.InvoiceItemDescription2
                                                   // = "";
      invDetailMap.put("posTaxInvSubSerialNo", ""); // InvMiscD.InvoiceItemSerialNo
                                                    // = "";
      // InvMiscD.InvoiceItemQuantity =
      // int.Parse(itm.GetDataKeyValue("ItemQty").ToString());
      // InvMiscD.InvoiceItemUnitPrice =
      // decimal.Parse(itm.GetDataKeyValue("ItemUnitPrice").ToString());
      invDetailMap.put("posTaxInvSubGSTRate", 0); // InvMiscD.InvoiceItemGSTRate
                                                  // = 6;
      // InvMiscD.InvoiceItemGSTTaxes =
      // Convert.ToDecimal(string.Format("{0:0.00}",
      // decimal.Parse(itm["ItemTotalAmt"].Text) -
      // (decimal.Parse(itm["ItemTotalAmt"].Text) * 100 / 106)));
      // InvMiscD.InvoiceItemCharges =
      // Convert.ToDecimal(string.Format("{0:0.00}",
      // (decimal.Parse(itm["ItemTotalAmt"].Text) * 100 / 106)));
      // InvMiscD.InvoiceItemAmountDue =
      // decimal.Parse(itm.GetDataKeyValue("ItemTotalAmt").ToString());

      // TODO 추후 삭제
      /* ### Masic Address 미반영 ### */
      /*
       * invDetailMap.put("posTaxInvSubAddr1", ""); //InvMiscD.InvoiceItemAdd1 =
       * ""; invDetailMap.put("posTaxInvSubAddr2", "");
       * //InvMiscD.InvoiceItemAdd2 = ""; invDetailMap.put("posTaxInvSubAddr3",
       * ""); //InvMiscD.InvoiceItemAdd3 = "";
       * invDetailMap.put("posTaxInvSubAddr4", ""); ////InvMiscD.InvoiceItemAdd3
       * = null; invDetailMap.put("posTaxInvSubPostCode", "");
       * //InvMiscD.InvoiceItemPostCode = "";
       * invDetailMap.put("posTaxInvSubAreaName", ""); // areaName
       * invDetailMap.put("posTaxInvSubStateName", "");
       * //InvMiscD.InvoiceItemStateName = "";
       * invDetailMap.put("posTaxInvSubCntry", "");
       * //InvMiscD.InvoiceItemCountry = "";
       */
      LOGGER.info(
          "############### 7 - " + idx + " POS ACC TAX INVOICE MISCELLANEOUS_SUB  INSERT START  ################");
      LOGGER.info("############### 7 - " + idx + " POS ACC TAX INVOICE MISCELLANEOUS_SUB  INSERT param : "
          + invDetailMap.toString());
      posMapper.insertPosTaxInvcMiscSub(invDetailMap);
      LOGGER.info("############### 7 - " + idx + " POS ACC TAX INVOICE MISCELLANEOUS END  ################");
    }

    // 8.
    // *********************************************************************************************************
    // InvStkRecordCard --> Only For Filter/Spare Part Type

    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)) { // insPosSystemType
                                                                                                       // ==
                                                                                                       // 1352
                                                                                                       // POS_SALES_TYPE_FILTER
                                                                                                       // posMap

      for (int idx = 0; idx < basketGrid.size(); idx++) {

        Map<String, Object> recordlMap = (Map<String, Object>) basketGrid.get(idx);

        // LOG0014D
        int stkRecordSeq = posMapper.getSeqLog0014D();

        recordlMap.put("stkRecordSeq", stkRecordSeq); // invStkCard.SRCardID =
                                                      // 0;
        // TODO brnchId 를 넣을건지 , locId 를 넣을 건지 선택해야함 (현재는 BranchId)
        // Location ID? Branch ID? == Location Id (now)
        // invStkCard.StockID =
        // int.Parse(itm.GetDataKeyValue("ItemStkID").ToString());
        // invStkCard.EntryDate =
        // Convert.ToDateTime(this.dpSalesDate.SelectedDate);
        recordlMap.put("invStkRecordTypeId", SalesConstants.POS_INV_STK_TYPE_ID); // invStkCard.TypeID
                                                                                  // =
                                                                                  // 571;
        recordlMap.put("invStkRecordRefNo", docNoPsn); // invStkCard.RefNo = "";
                                                       // //update later //POS
                                                       // No. 144Doc
        recordlMap.put("invStkRecordOrdId", 0); // invStkCard.SalesOrderId = 0;
        recordlMap.put("invStkRecordItmNo", idx); // invStkCard.ItemNo = count;
        recordlMap.put("invStkRecordSourceId", SalesConstants.POS_INV_SOURCE_ID); // invStkCard.SourceID
                                                                                  // =
                                                                                  // 477;
        recordlMap.put("invStkRecordProjectId", 0); // invStkCard.ProjectID = 0;
        recordlMap.put("invStkRecordBatchNo", 0); // invStkCard.BatchNo = 0;
        // invStkCard.Qty =
        // -int.Parse(itm.GetDataKeyValue("ItemQty").ToString());
        recordlMap.put("invStkRecordCurrId", SalesConstants.POS_INV_CURR_ID); // invStkCard.CurrID
                                                                              // =
                                                                              // 479;
        recordlMap.put("invStkRecordCurrRate", SalesConstants.POS_INV_CURR_RATE); // invStkCard.CurrRate
                                                                                  // =
                                                                                  // 1;
        recordlMap.put("invStkRecordCost", 0); // invStkCard.Cost = 0;
        recordlMap.put("invStkRecordPrice", 0); // invStkCard.Price = 0;
        recordlMap.put("invStkRecordRem", posMap.get("posRemark")); // invStkCard.Remark
                                                                    // =
                                                                    // !string.IsNullOrEmpty(this.txtRemark.Text.Trim())
                                                                    // ?
                                                                    // this.txtRemark.Text.Trim()
                                                                    // : "";
        recordlMap.put("invStkRecordSerialNo", ""); // invStkCard.SerialNo = "";
        recordlMap.put("invStkRecordInstallNo", ""); // invStkCard.InstallNo =
                                                     // "";
        // invStkCard.CostDate = DateTime.Now;
        recordlMap.put("invStkRecordAppTypeId", 0); // invStkCard.AppTypeID = 0;
        recordlMap.put("invStkRecordStkGrade", ""); // invStkCard.StkGrade =
                                                    // string.Empty;
        recordlMap.put("invStkRecordInstallFail", 0); // invStkCard.InstallFail
                                                      // = false;
        recordlMap.put("invStkRecordIsSynch", 0); // invStkCard.IsSynch = false;
        recordlMap.put("invStkRecordEntryMthId", 0); // ENTRY_MTH_ID

        LOGGER.info("############### 8. POS InvStkRecordCard INSERT START  ################");
        LOGGER.info("############### 8. POS InvStkRecordCard INSERT param : " + recordlMap.toString());
        posMapper.insertStkRecord(recordlMap);
        LOGGER.info("############### 8. POS InvStkRecordCard END  ################");

      }
    } // end 8

    // ********************* PAYMENT LOGIC START ********************* //
    // When 'POS SALES' Case
    if ((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2390
                                                                                                                   // --
                                                                                                                   // POS
                                                                                                                   // SALES

      /* params Setting */
      String trxNo = "";
      String worNo = "";
      int trxSeq = 0;
      int groupSeq = 0;

      Map<String, Object> trxMap = new HashMap<String, Object>();

      // DOC(23)
      // TODO 문서 채번 후 미사용
      params.put("docNoId", SalesConstants.POS_DOC_NO_TRX_NO); // (23)
      trxNo = posMapper.getDocNo(params);

      // DOC(3)
      params.put("docNoId", SalesConstants.POS_DOC_NO_WOR_NO); // (3)
      worNo = posMapper.getDocNo(params);

      // Seq
      trxSeq = posMapper.getSeqPay0069D();
      groupSeq = posMapper.getSeqPay0240T();

      // 9.
      // *********************************************************************************************************
      // PAY X

      trxMap.put("trxSeq", trxSeq);
      trxMap.put("trxType", SalesConstants.POS_TRX_TYPE_ID);
      trxMap.put("trxAmt", payFormMap.get("hidTotPayAmt"));
      // trxMap.put("trxNo", trxNo); //doc Number 미사용
      trxMap.put("trxMatchNo", "");

      LOGGER.info("############### 9. POS PAYX INSERT START  ################");
      LOGGER.info("############### 9. POS PAYX INSERT param : " + trxMap.toString());
      posMapper.insertPayTrx(trxMap);
      LOGGER.info("############### 9. POS PAYX END  ################");

      // 10.
      // *********************************************************************************************************
      // PAY M

      Map<String, Object> paymMap = new HashMap<String, Object>();

      int payMseq = posMapper.getSeqPay0064D();

      paymMap.put("payMseq", payMseq);
      paymMap.put("orNo", worNo); // doc
      paymMap.put("salesOrdId", SalesConstants.POS_TEMP_SALES_ORDER_ID); // 0
      paymMap.put("billId", posBillSeq); // accbilling.billId ( payM.BillID =
                                         // accbilling.BillID;)

      // trno = txtTrRefNo
      String trNo = "";
      if (payFormMap.get("payTrRefNo") != null) {
        trNo = String.valueOf(payFormMap.get("payTrRefNo"));
        trNo = trNo.trim().toUpperCase();
      } else {
        trNo = " ";
      }
      paymMap.put("trNo", trNo); // payM.TRNo =
                                 // (!string.IsNullOrEmpty(this.txtTrRefNo.Text.Trim()))
                                 // ? this.txtTrRefNo.Text.ToUpper() : "";
      paymMap.put("typeId", SalesConstants.POS_PAY_MASTER_TYPE_ID); // 577
      paymMap.put("bankChgAmt", SalesConstants.POS_BANK_CHARGE_AMOUNT);
      paymMap.put("bankChgAccId", SalesConstants.POS_BANK_CHARGE_ACCOUNT_ID);
      paymMap.put("collMemId", SalesConstants.POS_COLL_MEMBER_ID);

      // brnchId
      paymMap.put("brnchId", payFormMap.get("payBrnchCode"));

      // Debtor Acc.
      paymMap.put("bankAccId", payFormMap.get("payDebtorAcc"));

      paymMap.put("allowComm", SalesConstants.POS_PAY_ALLOW_COMM);
      paymMap.put("stusCodeId", SalesConstants.POS_PAY_STATUS_ID);

      // userId
      paymMap.put("updUserId", params.get("userId"));

      paymMap.put("syncCheck", SalesConstants.POS_PAY_SYNC_CHECK);
      paymMap.put("thirdPartyCustId", SalesConstants.POS_THIRD_PARTY_CUST_ID);

      // total Amt
      paymMap.put("totAmt", payFormMap.get("hidTotPayAmt"));
      paymMap.put("matchId", SalesConstants.POS_MATCH_ID);

      // userId
      paymMap.put("crtUserId", params.get("userId"));
      paymMap.put("isAllowRevMulti", SalesConstants.POS_IS_ALLOW_REV_MULTY);
      paymMap.put("isGlPostClm", SalesConstants.POS_IS_GL_POST_CLAIM);
      paymMap.put("glPostClmDt", SalesConstants.DEFAULT_DATE);
      paymMap.put("trxSeq", trxSeq); // trxId
      paymMap.put("advMonth", SalesConstants.POS_ADV_MONTH);
      paymMap.put("orderBillId", accOrderBillSeq); // payM.AccBillID =
                                                   // accorderbill.AccBillID;

      // TR Issued Date
      if (payFormMap.get("payTrIssueDate") != null) {
        paymMap.put("trIssuDt", payFormMap.get("payTrIssueDate"));
      } else {
        paymMap.put("trIssuDt", SalesConstants.DEFAULT_DATE);
      }

      paymMap.put("payInvIsGen", SalesConstants.POS_TAX_INVOICE_GENERATED);
      paymMap.put("taxInvcRefNo", docNoInvoice); // payM.TaxInvoiceRefNo =
                                                 // InvoiceNum;
      paymMap.put("svcCntrctId", SalesConstants.POS_SERVICE_CONTRACT_ID);
      paymMap.put("batchPayId", SalesConstants.POS_BATCH_PAYMEMNT_ID);

      LOGGER.info("############### 10. POS PAYM INSERT START  ################");
      LOGGER.info("############### 10. POS PAYM INSERT param : " + paymMap.toString());
      posMapper.insertPayMaster(paymMap);
      LOGGER.info("############### 10. POS PAYM END  ################");

      // Grid == payGrid
      // Grid Size 만큼 for문
      for (int idx = 0; idx < payGrid.size(); idx++) {
        Map<String, Object> paydMap = new HashMap<String, Object>();

        paydMap = (Map<String, Object>) payGrid.get(idx);

        // 11.
        // *********************************************************************************************************
        // PAY D (LOOP)
        // setting
        int posDSeq = 0;
        posDSeq = posMapper.getSeqPay0065D();
        paydMap.put("payItemId", posDSeq);
        paydMap.put("payId", payMseq);

        if (paydMap.get("transactionRefNo") != null && "" != paydMap.get("transactionRefNo")) {
          String payRefNo = "";
          payRefNo = String.valueOf(paydMap.get("transactionRefNo"));
          payRefNo = payRefNo.toUpperCase();
          paydMap.put("transactionRefNo", payRefNo);
        }

        if (paydMap.get("payCrcMode") != null && "" != paydMap.get("payCrcMode")) {
          String payCrcMode = "";
          payCrcMode = String.valueOf(paydMap.get("payCrcMode"));

          if (("ONLINE").equals(payCrcMode)) {
            paydMap.put("payCrcMode", "1");
          } else {
            paydMap.put("payCrcMode", "0");
          }
        } else {
          paydMap.put("payCrcMode", "0");
        }

        if (paydMap.get("payRefDate") == null || paydMap.get("payRefDate") == "") {
          paydMap.put("payRefDate", SalesConstants.DEFAULT_DATE);
        }

        paydMap.put("payItmStusId", SalesConstants.POS_PAY_STATUS_ID);

        paydMap.put("payItmIsLok", SalesConstants.POS_PAY_ITEM_IS_LOCK);
        paydMap.put("payItmIsThirdParty", SalesConstants.POS_PAY_ITEM_IS_THIRD_PARTY);
        paydMap.put("isFundTrnsfr", SalesConstants.POS_IS_FUND_TRANS_FR);
        paydMap.put("skipRecon", SalesConstants.POS_SKIP_RECON);

        LOGGER.info("############### 11 -[" + idx + "]. POS PAYD INSERT START  ################");
        LOGGER.info("############### 11 -[" + idx + "]. POS PAYD INSERT param : " + paydMap.toString());
        posMapper.insertPayDetail(paydMap);
        LOGGER.info("############### 11 -[" + idx + "]. POS PAYD INSERT END  ################");

        // 11.
        // *********************************************************************************************************
        // ACCGLROUTE (LOOP)
        // SUSPENDACCID 와 SETTLEACCID 세팅
        int suspendAccId = 0;
        int settleAccId = 0;

        if (Integer.parseInt(String.valueOf(paydMap.get("payMode"))) == SalesConstants.POS_PAY_METHOD_CASH) { // 105
                                                                                                              // Cash
          suspendAccId = SalesConstants.POS_PAY_SUSPEND_CASH; // 531
          settleAccId = Integer.parseInt(String.valueOf(paydMap.get("payBankAccount")));

        } else if (Integer.parseInt(String.valueOf(paydMap.get("payMode"))) == SalesConstants.POS_PAY_METHOD_CARD) { // 107
                                                                                                                     // Card
          suspendAccId = Integer.parseInt(String.valueOf(paydMap.get("payBankAccount")));

          switch (Integer.parseInt(String.valueOf(paydMap.get("payBankAccount")))) {
            case SalesConstants.POS_ITE_BANK_ACC_99:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_83;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_100:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_90;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_101:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_84;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_103:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_83;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_104:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_86;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_105:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_85;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_106:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_84;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_107:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_88;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_497:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_497;
              break;
            default:
              break;
          }// switch end
        } else if (Integer
            .parseInt(String.valueOf(paydMap.get("payMode"))) == SalesConstants.POS_PAY_METHOD_COMMISSION) { // 108
                                                                                                             // commission

          suspendAccId = SalesConstants.POS_PAY_SUSPEND_COMMISSION; // 533
          settleAccId = Integer.parseInt(String.valueOf(paydMap.get("payBankAccount")));

        }

        LOGGER.info("#########################  suspendAccId : " + suspendAccId);
        LOGGER.info("#########################  settleAccId : " + settleAccId);
        Map<String, Object> glrouteMap = new HashMap<String, Object>();

        // SEQ 생성
        int glSeq = posMapper.getSeqPay0009D();

        glrouteMap.put("glSeq", glSeq); // glroute.ID = 0;
        // SYSDATE //glroute.GLPostingDate = DateTime.Now;
        glrouteMap.put("glFisCalDate", SalesConstants.DEFAULT_DATE); // glroute.GLFiscalDate
                                                                     // =
                                                                     // DateTime.Parse(string.Format("{0:dd/MM/yyyy}",
                                                                     // "1900-01-01"));
        glrouteMap.put("glBatchNo", trxSeq); // glroute.GLBatchNo =
                                             // paytrx.TrxID.ToString();
        glrouteMap.put("glBatchTypeDesc", ""); // glroute.GLBatchTypeDesc = "";
        glrouteMap.put("glBatchTotal", payFormMap.get("hidTotPayAmt")); // glroute.GLBatchTotal
                                                                        // =
                                                                        // (double)payM.TotalAmt;
        glrouteMap.put("glReceiptNo", worNo); // glroute.GLReceiptNo = orNo;
        glrouteMap.put("glReceiptTypeId", SalesConstants.POS_RECEIPT_TYPE_ID); // glroute.GLReceiptTypeID
                                                                               // =
                                                                               // 577;
        glrouteMap.put("glReceiptBranchId", payFormMap.get("payBrnchCode")); // glroute.GLReceiptBranchID
                                                                             // =
                                                                             // (int)payM.BranchID;
        glrouteMap.put("glReceiptSettleAccId", settleAccId); // glroute.GLReceiptSettleAccID
                                                             // = SettleAccID;
        glrouteMap.put("glReceiptAccountId", suspendAccId); // glroute.GLReceiptAccountID
                                                            // = SuspendAccID;
        glrouteMap.put("glReceiptItemId", posDSeq); // glroute.GLReceiptItemID =
                                                    // pd.PayItemID;
        glrouteMap.put("glReceiptItemModeId", paydMap.get("payMode")); // glroute.GLReceiptItemModeID
                                                                       // =
                                                                       // (int)pd.PayItemModeID;
        glrouteMap.put("glReverseReceiptItemId", SalesConstants.POS_GL_REVERSE_RECEIPT_ITEM_ID); // glroute.GLReverseReceiptItemID
                                                                                                 // =
                                                                                                 // 0;
        glrouteMap.put("glReceiptItemAmount", paydMap.get("payAmt")); // glroute.GLReceiptItemAmount
                                                                      // =
                                                                      // (double)pd.PayItemAmt;
        glrouteMap.put("glReceiptItemCharges", SalesConstants.POS_GL_RECEIPT_ITEM_CHARGES); // glroute.GLReceiptItemCharges
                                                                                            // =
                                                                                            // 0;
        glrouteMap.put("glReceiptItemRclStatus", SalesConstants.POS_GL_RECEIPT_ITEM_RCL_STATUS); // glroute.GLReceiptItemRCLStatus
                                                                                                 // =
                                                                                                 // "N";
        glrouteMap.put("glConversionStatus", SalesConstants.POS_GL_CONVERSION_STATUS); // glroute.GLConversionStatus
                                                                                       // =
                                                                                       // "Y";

        LOGGER.info("############### 12 -[" + idx + "]. POS ACCGLROUTE INSERT START  ################");
        LOGGER.info("############### 12 -[" + idx + "]. POS ACCGLROUTE INSERT param : " + glrouteMap.toString());
        posMapper.insertAccGlRoute(glrouteMap);
        LOGGER.info("############### 12 -[" + idx + "]. POS ACCGLROUTE INSERT END  ################");

        /****** ADD LOGIC : INSERT PAY0252T // ADD BY LEE SH (2018/01/25) ****/
        Map<String, Object> payTMap = new HashMap<String, Object>();

        payTMap.put("groupSeq", groupSeq);
        payTMap.put("prcssSeq", idx);
        payTMap.put("trxId", trxSeq);
        payTMap.put("payId", payMseq);
        payTMap.put("payItmId", posDSeq);
        payTMap.put("payItmModeId", paydMap.get("payMode"));
        payTMap.put("totAmt", payFormMap.get("hidTotPayAmt"));
        payTMap.put("payItmAmt", paydMap.get("payAmt"));
        payTMap.put("bankChgAmt", paymMap.get("bankChgAmt"));
        payTMap.put("appType", SalesConstants.POS_PAY_APP_TYPE); // POS
        payTMap.put("payRoute", SalesConstants.POS_PAY_ROUTE);
        payTMap.put("payKeyinScrn", SalesConstants.POS_PAY_KEY_IN_SCRN);
        payTMap.put("ldgrType", SalesConstants.POS_PAY_LEDGER_TYPE);

        LOGGER.info("############### 13 -[" + idx + "]. POS PAYT INSERT START  ################");
        LOGGER.info("############### 13 -[" + idx + "]. POS PAYT INSERT param : " + payTMap.toString());
        posMapper.insertPayT(payTMap);
        LOGGER.info("############### 13 -[" + idx + "]. POS PAYT INSERT END  ################");

      } // Loop End
        // PAYMENT GRID 가져옴
    }

    // ********************* PAYMENT LOGIC END ********************* //

    // 10.
    // *********************************************************************************************************
    // BOOKING

    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)) { // POS
                                                                                                       // -
                                                                                                       // FILTER
                                                                                                       // /
                                                                                                       // SPARE
                                                                                                       // PART
                                                                                                       // /
                                                                                                       // MISCELLANEOUS

      Map<String, Object> logPram = new HashMap<String, Object>();

      logPram.put("psno", docNoPsn);
      logPram.put("retype", "REQ");
      logPram.put("pType", "PS01"); // PS02 - cancel
      logPram.put("pPrgNm", "PointOfSales");
      logPram.put("userId", Integer.parseInt(String.valueOf(params.get("userId"))));

      LOGGER.info("############### 10. POS LOGISTIC REQUEST START  ################");
      LOGGER.info("#########  call Procedure Params : " + logPram.toString());

      posMapper.posBookingCallSP_LOGISTIC_POS(logPram);

      String reqResult = String.valueOf(logPram.get("p1"));
      LOGGER.debug("############ Procedure Result :  " + reqResult);
      LOGGER.info("############### 10. POS LOGISTIC REQUEST END  ################");
      //

      LOGGER.info("################################## return value(docNoPsn): " + docNoPsn);
      // retrun Map
      Map<String, Object> rtnMap = new HashMap<String, Object>();
      rtnMap.put("reqDocNo", docNoPsn);
      rtnMap.put("psno", docNoPsn);

      // GetDetailList
      List<EgovMap> revDetList = null;
      rtnMap.put("rcvStusId", SalesConstants.POS_DETAIL_NON_RECEIVE);
      revDetList = posMapper.getPosItmIdListByPosNo(rtnMap);
      LOGGER.info("revDetList : " + revDetList);
      for (int idx = 0; idx < revDetList.size(); idx++) {

        // GI Call Procedure
        Map<String, Object> giMap = new HashMap<String, Object>();

        giMap.put("psno", docNoPsn);
        giMap.put("retype", "COM");
        giMap.put("pType", "PS01");
        giMap.put("posItmId", revDetList.get(idx).get("posItmId"));
        giMap.put("pPrgNm", "PointOfSales");
        giMap.put("userId", params.get("userId"));

        LOGGER.info("############### 11. POS GI COMPLETE START : " + idx + "  ################");
        LOGGER.info("#########  call Procedure Params : " + giMap.toString());
        posMapper.posGICallSP_LOGISTIC_POS(giMap);
        reqResult = String.valueOf(giMap.get("p1"));
        LOGGER.info("rtnResult : " + reqResult);
        LOGGER.info("############### 11. POS GI COMPLETE  END : " + idx + " ################");

        /*
         * rtnMap.put("logError", reqResult); //rtnMap.put("logError", "000");
         * return rtnMap;
         */

      }

      rtnMap.put("logError", reqResult);
      // rtnMap.put("logError", "000");
      return rtnMap;

    }



    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK)) { // item bank
        LOGGER.info("########## add by leo , 14-07-2021##################");
        LOGGER.info("# If it is an item bank, stock out  from  LOG0106M#");

        LOGGER.info("posMap===" +posMap.toString());
        LOGGER.info("basketGrid===" +basketGrid.toString());
        for (int i = 0; i < basketGrid.size(); i++) {

            Map<String, Object> itemMap = (Map<String, Object>) basketGrid.get(i);

            Map<String, Object>  log106map = new HashMap<String, Object>();
            log106map.put("itemRecvQty", itemMap.get("inputQty"));
            log106map.put("logId", posMap.get("cmbWhBrnchIdPop"));
            log106map.put("itemCode", itemMap.get("stkId"));
            log106map.put("userId", params.get("userId"));


            LOGGER.info("log106map===>" +log106map.toString());

            posStockMapper.updateOutStockLOG0106M(log106map);



        }





        LOGGER.info("############################################");
    }



    // retrun Map
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("reqDocNo", docNoPsn);

    LOGGER.info("##################### POS Request Success!!! ######################################");
    LOGGER.info("##################### POS Request Success!!! ######################################");
    LOGGER.info("##################### POS Request Success!!! ######################################");

    // rtnMap.put("logError", reqResult);
    rtnMap.put("logError", "000");

    return rtnMap;
  }

  @Override
  public List<EgovMap> getUploadMemList(Map<String, Object> params) throws Exception {

    return posMapper.getUploadMemList(params);
  }

  @Override
  public EgovMap posReversalDetail(Map<String, Object> params) throws Exception {

    return posMapper.posReversalDetail(params);
  }

  @Override
  public List<EgovMap> getPosDetailList(Map<String, Object> params) throws Exception {

    return posMapper.getPosDetailList(params);
  }

  @Override
  public EgovMap chkReveralBeforeReversal(Map<String, Object> params) throws Exception {

    return posMapper.chkReveralBeforeReversal(params);
  }

  @Override
  @Transactional
  public EgovMap insertPosReversal(Map<String, Object> params) throws Exception {

    /* ########### get Params ############### */
    double rtnAmt = 0;
    double rtnCharge = 0;
    double rtnTax = 0;
    double rtnDisc = 0;
    double tempBillAmt = 0;

    String posRefNo = ""; // SOI no. (144)
    String voidNo = ""; // Void no. (112)
    String rptNo = ""; // RD no. (18)
    String cnno = ""; // CN-New (134)

    int posMasterSeq = 0;
    int posDetailDuducSeq = 0;
    int posBillSeq = 0;
    int memoAdjSeq = 0;
    int noteSeq = 0;
    int miscSubSeq = 0;
    int noteSubSeq = 0;
    int ordVoidSeq = 0;
    int ordVoidSubSeq = 0;
    int stkSeq = 0;
    int groupSeq = 0;

    String giResult = "";
    String reqResult = "";

    /*
     * ################################### Get Doc No
     * #############################
     */

    params.put("docNoId", SalesConstants.POS_DOC_NO_PSN_NO); // (144)
    posRefNo = posMapper.getDocNo(params);

    params.put("docNoId", SalesConstants.POS_DOC_NO_VOID_NO); // (112)
    voidNo = posMapper.getDocNo(params);

    params.put("docNoId", SalesConstants.POS_DOC_NO_RD_NO); // (18)
    rptNo = posMapper.getDocNo(params);

    params.put("docNoId", SalesConstants.POS_DOC_NO_CN_NEW_NO); // (134)
    cnno = posMapper.getDocNo(params);

    // 1.
    // *********************************************************************************************************
    // POS MASTER

    // Price and Qty Setting

    rtnAmt = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotAmt")));
    rtnCharge = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotChrg")));
    rtnTax = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotTxs")));
    rtnDisc = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotDscnt")));

    // Seq
    posMasterSeq = posMapper.getSeqSal0057D(); // master Sequence
    Map<String, Object> posMap = new HashMap<String, Object>();

    posMap.put("posMasterSeq", posMasterSeq); // posId = 0 -- 시퀀스
    posMap.put("docNoPsn", posRefNo); // posNo = 0 --문서채번
    posMap.put("posBillId", SalesConstants.POS_BILL_ID); // pos Bill Id // 0

    posMap.put("posCustName", params.get("rePosCustName")); // posCustName =
                                                            // other Income만 사용함
                                                            // .. 그러면 나머지는??
    posMap.put("insPosModuleType", params.get("rePosModuleTypeId"));
    posMap.put("insPosSystemType", SalesConstants.POS_SALES_TYPE_REVERSAL); // 1361
    posMap.put("posTotalAmt", rtnAmt);
    posMap.put("posCharge", rtnCharge);
    posMap.put("posTaxes", rtnTax);
    posMap.put("posDiscount", rtnDisc);
    posMap.put("hidLocId", params.get("rePosWhId"));
    posMap.put("posRemark", params.get("reversalRem"));
    posMap.put("posMtchId", params.get("rePosId")); // pos Old ID
    posMap.put("salesmanPopId", params.get("rePosMemId"));
    posMap.put("posCustomerId", SalesConstants.POS_CUST_ID); // 107205
    posMap.put("userId", params.get("userId"));

    /*
     * if(params.get("userDeptId") == null){ params.put("userDeptId", 0); }
     * posMap.put("userDeptId", params.get("userDeptId"));
     */
    posMap.put("userDeptId", 0);
    if (params.get("userDeptId") == null) {
      params.put("userDeptCode", " ");
    }
    posMap.put("userDeptCode", params.get("userDeptId"));
    posMap.put("crAccId", params.get("rePosCrAccId"));
    posMap.put("drAccId", params.get("rePosDrAccId"));
    posMap.put("posReason", params.get("rePosResnId"));
    posMap.put("cmbWhBrnchIdPop", params.get("rePosBrnchId")); // Brnch
    posMap.put("recvDate", params.get("rePosRcvDt"));
    posMap.put("posStusId", params.get("rePosStusId"));

    if (params.get("rePosModuleTypeId").equals(SalesConstants.POS_SALES_MODULE_TYPE_OTH)) {
      posMap.put("chkOth", SalesConstants.POS_OTH_CHECK_PARAM);
      posMap.put("getAreaId", params.get("getAreaId"));
      posMap.put("addrDtl", params.get("addrDtl"));
      posMap.put("streetDtl", params.get("streetDtl"));
    }

    // Pos Master Insert
    LOGGER.info("############### 1. POS MASTER REVERSAL INSERT START  ################");
    LOGGER.info("############### 1. POS MASTER REVERSAL INSERT param : " + posMap.toString());
    posMapper.insertPosReversalMaster(posMap);
    LOGGER.info("############### 1. POS MASTER REVERSAL INSERT END  ################");

    // 2.
    // *********************************************************************************************************
    // POS DETAIL

    List<EgovMap> oldDetailList = null;
    oldDetailList = posMapper.getOldDetailList(params); // Old Pos Id == param
    // old pos id 로 디테일 리스트 불러옴
    if (oldDetailList != null && oldDetailList.size() > 0) { // for (old List)

      for (int idx = 0; idx < oldDetailList.size(); idx++) {

        EgovMap revDetailMap = null;
        double tempTot = 0;
        double tempChrg = 0;
        double tempTxs = 0;
        int tempQty = 0;

        revDetailMap = oldDetailList.get(idx); // map 생성 --parameter // params
                                               // setting >> old List.get(i) >>
                                               // Map 에 put

        posDetailDuducSeq = posMapper.getSeqSal0058D(); // detail Sequence

        // detail 생성 ....
        revDetailMap.put("posDetailDuducSeq", posDetailDuducSeq); // seq
        revDetailMap.put("posMasterSeq", posMasterSeq); // master Seq

        tempQty = Integer.parseInt(String.valueOf(revDetailMap.get("posItmQty")));
        tempQty = -1 * tempQty;
        revDetailMap.put("posDetailQty", tempQty);

        tempTot = Double.parseDouble(String.valueOf(revDetailMap.get("posItmTot")));
        tempTot = -1 * tempTot;
        revDetailMap.put("posDetailTotal", tempTot);

        tempChrg = Double.parseDouble(String.valueOf(revDetailMap.get("posItmChrg")));
        tempChrg = -1 * tempChrg;
        revDetailMap.put("posDetailCharge", tempChrg);

        tempTxs = Double.parseDouble(String.valueOf(revDetailMap.get("posItmTxs")));
        tempTxs = -1 * tempTxs;
        revDetailMap.put("posDetailTaxs", tempTxs);

        revDetailMap.put("posRcvStusId", SalesConstants.POS_DETAIL_NON_RECEIVE); // RCV_STUS_ID
                                                                                 // ==
                                                                                 // 96
                                                                                 // (Non
                                                                                 // Receive)
        revDetailMap.put("userId", params.get("userId"));

        revDetailMap.put("locId", params.get("rePosBrnchId"));

        if (revDetailMap != null) {
          LOGGER.info("############### 2 - [" + idx + "]  POS DETAIL REVERSAL INSERT START  ################");
          LOGGER
              .info("############### 2 - [" + idx + "]  POS DETAIL REVERSAL INSERT param : " + revDetailMap.toString());
          posMapper.insertPosReversalDetail(revDetailMap);

          if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK)) {
            posMapper.updateLOG0106MDetail(revDetailMap);
          }

          LOGGER.info("############### 2 - [" + idx + "]  POS DETAIL REVERSAL INSERT END  ################");
        }
      }
      // 2 - 1 .
      // *********************************************************************************************************
      // POS DETAIL
      List<EgovMap> oldSerialList = null;
      oldSerialList = posMapper.chkOldReqSerial(params);

      if (oldSerialList != null && oldSerialList.size() > 0) {
        // Serial Insert
        for (int idx = 0; idx < oldSerialList.size(); idx++) {
          int serialSeq = posMapper.getSeqSal0147M();
          EgovMap oldSerialMap = oldSerialList.get(idx);

          Map<String, Object> serialMap = new HashMap<String, Object>();

          serialMap.put("serialSeq", serialSeq);
          serialMap.put("posMasterSeq", posMasterSeq);
          serialMap.put("stkId", oldSerialMap.get("posItmStockId")); // POS_ITM_STOCK_ID
          serialMap.put("serialNo", oldSerialMap.get("posSerialNo")); // POS_SERIAL_NO
          serialMap.put("userId", params.get("userId"));

          LOGGER.info("############### 2 - Serial - " + idx + "  POS SERIAL INSERT START  ################");
          LOGGER.info("############### 2 - Serial - " + idx + "  POS SERIAL INSERT param : " + serialMap.toString());
          posMapper.insertSerialNo(serialMap);
          LOGGER.info("############### 2 - Serial - " + idx + "  POS SERIAL INSERT END  ################");

        }
      }
    }

    EgovMap billInfoMap = null;
    billInfoMap = posMapper.getBillInfo(params);

    if (billInfoMap != null) {
      // 3.
      // *********************************************************************************************************
      // ACC BILLING
      tempBillAmt = Double.parseDouble(String.valueOf(billInfoMap.get("billAmt")));
      tempBillAmt = -1 * tempBillAmt;

      posBillSeq = posMapper.getSeqPay0007D(); // seq

      billInfoMap.put("billAmt", tempBillAmt);
      billInfoMap.put("posBillSeq", posBillSeq);
      billInfoMap.put("docNoPsn", posRefNo); // posNo = 0 --문서채번
      billInfoMap.put("userId", params.get("userId"));

      // insert
      LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE START  ################");
      LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE PARAM : " + billInfoMap.toString());
      posMapper.insertPosReversalBilling(billInfoMap);
      LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE END  ################");
      // 4.
      // *********************************************************************************************************
      // POS MASTER UPDATE BILL_ID
      // posMaster 의 만들어진 시퀀스 번호가 조건일때 posBillId == accBilling 의 시퀀스 ()
      Map<String, Object> posUpMap = new HashMap<String, Object>();
      posUpMap.put("posBillSeq", posBillSeq);
      posUpMap.put("posMasterSeq", posMasterSeq);
      LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER START  ################");
      LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER param : " + posUpMap.toString());
      posMapper.updatePosMasterPosBillId(posUpMap);
      LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER END  ################");

    }

    EgovMap taxInvMap = null;
    EgovMap getAccMap = null;
    taxInvMap = posMapper.getTaxInvoiceMisc(params); // PAY0031D miscM //
                                                     // MISC(M) MASTER

    if (taxInvMap != null) {
      // 5.
      // *********************************************************************************************************
      // ACC ORDER BILL
      Map<String, Object> accInfoMap = new HashMap<String, Object>();
      accInfoMap.put("taxInvcRefNo", taxInvMap.get("taxInvcRefNo"));

      getAccMap = posMapper.getAccOrderBill(accInfoMap); // 인서트 칠 인포메이션
                                                         // ACC_BILL_ID //

      if (getAccMap != null) {

        Map<String, Object> accOrdUpMap = new HashMap<String, Object>();

        accOrdUpMap.put("accBillId", getAccMap.get("accBillId"));
        accOrdUpMap.put("accBillStatus", SalesConstants.POS_ACC_BILL_STATUS); // 74
        accOrdUpMap.put("accBillTaskId", SalesConstants.POS_ACC_BILL_TASK_ID);

        LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE START  ################");
        LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE PARAM  : " + accOrdUpMap.toString());
        posMapper.updateAccOrderBillingWithPosReversal(accOrdUpMap);
        LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE END  ################");
      }
      // 6.
      // *********************************************************************************************************
      // INVOICE ADJUSTMENT (MASTER)

      Map<String, Object> adjMap = new HashMap<String, Object>();

      memoAdjSeq = posMapper.getSeqPay0011D();

      adjMap.put("memoAdjSeq", memoAdjSeq);
      adjMap.put("memoAdjRefNo", cnno); // 134 //InvAdjM.MemoAdjustRefNo = "";
                                        // //update later
      adjMap.put("memoAdjReptNo", rptNo); // 18 //InvAdjM.MemoAdjustReportNo =
                                          // ""; //update later
      adjMap.put("memoAdjTypeId", SalesConstants.POS_INV_ADJM_MEMO_TYPE_ID); // InvAdjM.MemoAdjustTypeID
                                                                             // =
                                                                             // 1293;
                                                                             // //Type
                                                                             // -
                                                                             // CN
      adjMap.put("memoAdjInvNo", taxInvMap.get("taxInvcRefNo")); // TAX_INVC_REF_NO
                                                                 // InvAdjM.MemoAdjustInvoiceNo
                                                                 // = "";
                                                                 // //update
                                                                 // later-InvoiceNo
                                                                 // BR68..
      adjMap.put("memoAdjInvTypeId", SalesConstants.POS_INV_ADJM_MEMO_INVOICE_TYPE_ID); // InvAdjM.MemoAdjustInvoiceTypeID
                                                                                        // =
                                                                                        // 128;
                                                                                        // //
                                                                                        // Invoice-Miscellaneous
      adjMap.put("memoAdjStatusId", SalesConstants.POS_INV_ADJM_MEMO_STATUS_ID); // InvAdjM.MemoAdjustStatusID
                                                                                 // =
                                                                                 // 4;
      adjMap.put("memoAdjReasonId", SalesConstants.POS_INV_ADJM_MEMO_RESN_ID); // InvAdjM.MemoAdjustReasonID
                                                                               // =
                                                                               // 2038;
                                                                               // //
                                                                               // Invoice
                                                                               // Reversal
      adjMap.put("memoAdjRem", params.get("reversalRem")); // rem
                                                           // InvAdjM.MemoAdjustRemark
                                                           // =
                                                           // this.txtReversalRemark.Text.Trim();
      adjMap.put("memoAdjTotTxs", taxInvMap.get("taxInvcTxs")); // TAX_INVC_TXS
                                                                // InvAdjM.MemoAdjustTaxesAmount
                                                                // =
                                                                // miscM.TaxInvoiceTaxes;
      adjMap.put("memoAdjTotAmt", taxInvMap.get("taxInvcAmtDue")); // TAX_INVC_AMT_DUE
                                                                   // InvAdjM.MemoAdjustTotalAmount
                                                                   // =
                                                                   // miscM.TaxInvoiceAmountDue;
      adjMap.put("userId", params.get("userId"));

      // insert
      LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT START  ################");
      LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT PARAM : " + adjMap.toString());
      posMapper.insertInvAdjMemo(adjMap);
      LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT END  ################");

      // 7.
      // *********************************************************************************************************
      // ACC TAX DEBIT CREDIT NOTE

      Map<String, Object> noteMap = new HashMap<String, Object>();

      noteSeq = posMapper.getSeqPay0027D();

      noteMap.put("noteSeq", noteSeq); // seq
      noteMap.put("memoAdjSeq", memoAdjSeq); // dcnM.NoteEntryID =
                                             // InvAdjM.MemoAdjustID;
      noteMap.put("noteTypeId", SalesConstants.POS_NOTE_TYPE_ID); // dcnM.NoteTypeID
                                                                  // = 1293;
                                                                  // //CN
      noteMap.put("noteGrpNo", taxInvMap.get("taxInvcSvcNo")); // dcnM.NoteGroupNo
                                                               // =
                                                               // miscM.TaxInvoiceServiceNo;
                                                               // TAX_INVC_SVC_NO
      noteMap.put("noteRefNo", cnno); // dcnM.NoteRefNo =
                                      // InvAdjM.MemoAdjustRefNo;
      noteMap.put("noteRefDate", taxInvMap.get("taxInvcRefDt")); // TAX_INVC_REF_DT
                                                                 // //dcnM.NoteRefDate
                                                                 // =
                                                                 // miscM.TaxInvoiceRefDate;
      noteMap.put("noteInvNo", taxInvMap.get("taxInvcRefNo")); // dcnM.NoteInvoiceNo
                                                               // =
                                                               // InvAdjM.MemoAdjustInvoiceNo;
      noteMap.put("noteInvTypeId", SalesConstants.POS_NOTE_INVOICE_TYPE_ID); // dcnM.NoteInvoiceTypeID
                                                                             // =
                                                                             // 128;
                                                                             // //MISC
      noteMap.put("noteInvCustName", taxInvMap.get("taxInvcCustName")); // dcnM.NoteCustName
                                                                        // =
                                                                        // miscM.TaxInvoiceCustName;
                                                                        // //TAX_INVC_CUST_NAME,
      noteMap.put("noteCntcPerson", taxInvMap.get("taxInvcCntcPerson")); // dcnM.NoteContatcPerson
                                                                         // =
                                                                         // miscM.TaxInvoiceContactPerson;
                                                                         // //TAX_INVC_CNTC_PERSON,
      /*
       * dcnM.NoteAddress1 = miscM.TaxInvoiceAddress1; dcnM.NoteAddress2 =
       * miscM.TaxInvoiceAddress2; dcnM.NoteAddress3 = miscM.TaxInvoiceAddress3;
       * dcnM.NoteAddress4 = miscM.TaxInvoiceAddress4; dcnM.NotePostCode =
       * miscM.TaxInvoicePostCode; dcnM.NoteAreaName = ""; dcnM.NoteStateName =
       * miscM.TaxInvoiceStateName; dcnM.NoteCountryName =
       * miscM.TaxInvoiceCountry;
       */
      noteMap.put("noteInvTxs", taxInvMap.get("taxInvcTxs")); // dcnM.NoteTaxes
                                                              // =
                                                              // miscM.TaxInvoiceTaxes;
      noteMap.put("noteInvChrg", taxInvMap.get("taxInvcChrg")); // dcnM.NoteCharges
                                                                // =
                                                                // miscM.TaxInvoiceCharges;
                                                                // //
                                                                // TAX_INVC_CHRG,
      noteMap.put("noteInvAmt", taxInvMap.get("taxInvcAmtDue")); // dcnM.NoteAmountDue
                                                                 // =
                                                                 // miscM.TaxInvoiceAmountDue;

      String soRem = String.valueOf(taxInvMap.get("taxInvcSvcNo"));
      noteMap.put("noteRem", SalesConstants.POS_REM_SOI_COMMENT + soRem); // dcnM.NoteRemark
                                                                          // =
                                                                          // "SOI
                                                                          // Reversal
                                                                          // - "
                                                                          // +
                                                                          // miscM.TaxInvoiceServiceNo;
      noteMap.put("noteStatusId", SalesConstants.POS_NOTE_STATUS_ID); // dcnM.NoteStatusID
                                                                      // = 4;
      noteMap.put("userId", params.get("userId"));

      LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT START  ################");
      LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT PARAM :  " + noteMap.toString());
      posMapper.insertTaxDebitCreditNote(noteMap);
      LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT END  ################");

      Map<String, Object> miscSubMap = new HashMap<String, Object>();
      miscSubMap.put("taxInvcId", taxInvMap.get("taxInvcId"));
      List<EgovMap> miscSubList = null;
      miscSubList = posMapper.getMiscSubList(miscSubMap);

      if (null != miscSubList && miscSubList.size() > 0) {

        for (int idx = 0; idx < miscSubList.size(); idx++) {
          // 8.
          // *********************************************************************************************************
          // INVOICE ADJUSTMENT SUB
          EgovMap tempSubMap = null;
          tempSubMap = miscSubList.get(idx);

          miscSubSeq = posMapper.getSeqPay0012D();
          Map<String, Object> accInvSubMap = new HashMap<String, Object>();
          accInvSubMap.put("miscSubSeq", miscSubSeq);
          accInvSubMap.put("memoAdjSeq", memoAdjSeq); // memoAdjSeq
          accInvSubMap.put("memoSubItmInvItmId", tempSubMap.get("invcItmId")); // INVC_ITM_ID
          accInvSubMap.put("memoSubItmInvItmQty", tempSubMap.get("invcItmQty")); // INVC_ITM_QTY

          accInvSubMap.put("memoSubItmCrditAccId", params.get("rePosCrAccId"));
          accInvSubMap.put("memoSubItmDebtAccId", params.get("rePosDrAccId"));
          accInvSubMap.put("memoSubItmTaxCodeId", getAccMap.get("accBillTaxCodeId"));
          accInvSubMap.put("memoSubItmStusId", SalesConstants.POS_MEMO_ITM_STATUS_ID); // 1
          accInvSubMap.put("memoSubItmRem", params.get("reversalRem")); //// InvAdjM.MemoAdjustRemark;

          accInvSubMap.put("memoSubItmInvItmGSTRate", tempSubMap.get("invcItmGstRate")); // INVC_ITM_GST_RATE
          accInvSubMap.put("memoSubItmInvItmCharges", tempSubMap.get("invcItmChrg")); // INVC_ITM_CHRG
          accInvSubMap.put("memoSubItmInvItmTaxes", tempSubMap.get("invcItmGstTxs")); // INVC_ITM_GST_TXS
          accInvSubMap.put("memoSubItmInvItmAmount", tempSubMap.get("invcItmAmtDue")); // INVC_ITM_AMT_DUE

          LOGGER.info(
              "############### 8 - [" + idx + "] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT START  ################");
          LOGGER.info("############### 8 - [" + idx + "] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT PARAM : "
              + accInvSubMap.toString());
          posMapper.insertInvAdjMemoSub(accInvSubMap);
          LOGGER.info(
              "############### 8 - [" + idx + "] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT END  ################");

          // 9.
          // *********************************************************************************************************
          // ACC TAX DEBIT CREDIT NOTE SUB

          Map<String, Object> noteSubMap = new HashMap<String, Object>();
          noteSubSeq = posMapper.getSeqPay0028D();

          noteSubMap.put("noteSubSeq", noteSubSeq);
          noteSubMap.put("noteSeq", noteSeq); // dcnS.NoteID = dcnM.NoteID;
          noteSubMap.put("noteSubItmId", tempSubMap.get("invcItmId")); // dcnS.NoteItemInvoiceItemID
                                                                       // =
                                                                       // miscSub.InvocieItemID;
          noteSubMap.put("noteSubOrdNo", tempSubMap.get("invcItmOrdNo")); // dcnS.NoteItemOrderNo
                                                                          // =
                                                                          // miscSub.InvoiceItemOrderNo;
          noteSubMap.put("noteSubItmProductModel", tempSubMap.get("invcItmDesc1")); // dcnS.NoteItemProductModel
                                                                                    // =
                                                                                    // miscSub.InvoiceItemDescription1;
          noteSubMap.put("noteSubItmSerialNo", tempSubMap.get("invcItmSerialNo")); // dcnS.NoteItemSerialNo
                                                                                   // =
                                                                                   // miscSub.InvoiceItemSerialNo;
          noteSubMap.put("noteSubItmInstDt", tempSubMap.get("invcItmInstallDt")); // dcnS.NoteItemInstallationDate
                                                                                  // =
                                                                                  // miscSub.InvoiceItemInstallDate;
          /*
           * dcnS.NoteItemAdd1 = miscSub.InvoiceItemAdd1; dcnS.NoteItemAdd2 =
           * miscSub.InvoiceItemAdd2; dcnS.NoteItemAdd3 =
           * miscSub.InvoiceItemAdd3; dcnS.NoteItemAdd4 =
           * miscSub.InvoiceItemAdd4; dcnS.NoteItemPostcode =
           * miscSub.InvoiceItemPostCode; dcnS.NoteItemAreaName =
           * miscSub.InvoiceItemAreaName; dcnS.NoteItemStateName =
           * miscSub.InvoiceItemStateName; dcnS.NoteItemCountry =
           * miscSub.InvoiceItemCountry;
           */
          noteSubMap.put("noteSubItmQty", tempSubMap.get("invcItmQty")); // dcnS.NoteItemQuantity
                                                                         // =
                                                                         // miscSub.InvoiceItemQuantity;
          noteSubMap.put("noteSubItmUnitPrc", tempSubMap.get("invcItmUnitPrc")); // dcnS.NoteItemUnitPrice
                                                                                 // =
                                                                                 // miscSub.InvoiceItemUnitPrice;
          noteSubMap.put("noteSubItmGstRate", tempSubMap.get("invcItmGstRate")); // dcnS.NoteItemGSTRate
                                                                                 // =
                                                                                 // miscSub.InvoiceItemGSTRate;
          noteSubMap.put("noteSubItmGstTxs", tempSubMap.get("invcItmGstTxs")); // dcnS.NoteItemGSTTaxes
                                                                               // =
                                                                               // miscSub.InvoiceItemGSTTaxes;
          noteSubMap.put("noteSubItmChrg", tempSubMap.get("invcItmChrg")); // dcnS.NoteItemCharges
                                                                           // =
                                                                           // miscSub.InvoiceItemCharges;
          noteSubMap.put("noteSubItmDueAmt", tempSubMap.get("invcItmAmtDue")); // dcnS.NoteItemDueAmount
                                                                               // =
                                                                               // miscSub.InvoiceItemAmountDue;

          LOGGER.info("############### 9 - [" + idx
              + "] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT START  ################");
          LOGGER.info("############### 9 - [" + idx + "] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT PARAM : "
              + noteSubMap.toString());
          posMapper.insertTaxDebitCreditNoteSub(noteSubMap);
          LOGGER.info("############### 9 - [" + idx
              + "] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT END  ################");
        }

      }

      // 10.
      // *********************************************************************************************************
      // ACC ORDER VOID INVOICE
      /*
       * Map<String, Object> ordVoidInvMap = new HashMap<String, Object>();
       *
       * ordVoidSeq = posMapper.getSeqPay0017D();
       *
       * ordVoidInvMap.put("ordVoidSeq", ordVoidSeq); //nvVoidM.AccInvVoidID =
       * 0; ordVoidInvMap.put("voidNo", voidNo); //InvVoidM.AccInvVoidRefNo =
       * VoidNo; ordVoidInvMap.put("accInvVoidRefNo",
       * taxInvMap.get("taxInvcRefNo")); //InvVoidM.AccInvVoidInvoiceNo =
       * miscM.TaxInvoiceRefNo; ordVoidInvMap.put("accInvVoidInvcAmt",
       * params.get("rePosTotAmt")); //ACC_INV_VOID_INVC_AMT String voidRem =
       * String.valueOf(params.get("rePosNo"));
       * ordVoidInvMap.put("accInvVoidRem",
       * SalesConstants.POS_REM_SOI_COMMENT_INV_VOID + voidRem);
       * //ACC_INV_VOID_REM // InvVoidM.AccInvVoidRemark = "SOI Reversal_" +
       * this.txtReferenceNo.Text.Trim(); ordVoidInvMap.put("accInvVoidStausId",
       * SalesConstants.POS_ACC_INV_VOID_STATUS); //InvVoidM.AccInvVoidStatusID
       * = 1; ordVoidInvMap.put("userId", params.get("userId"));
       *
       * LOGGER.info(
       * "############### 10. POS ACC ORDER VOID INVOICE REVERSAL INSERT START  ################"
       * ); LOGGER.info(
       * "############### 10. POS ACC ORDER VOID INVOICE REVERSAL INSERT PARAM : "
       * + ordVoidInvMap.toString());
       * posMapper.insertAccOrderVoidInv(ordVoidInvMap); LOGGER.info(
       * "############### 10. POS ACC ORDER VOID INVOICE REVERSAL INSERT END  ################"
       * );
       */
      // 11.
      // *********************************************************************************************************
      // ACC ORDER VOID INVOICE SUB
      /*
       * Map<String, Object> ordVoidSubMap = new HashMap<String, Object>();
       *
       * ordVoidSubSeq = posMapper.getSeqPay0018D();
       *
       * ordVoidSubMap.put("ordVoidSubSeq", ordVoidSubSeq);
       * ordVoidSubMap.put("ordVoidSeq", ordVoidSeq); //InvVoidS.AccInvVoidID =
       * InvVoidM.AccInvVoidID; ordVoidSubMap.put("ordVoidSubOrdId",
       * SalesConstants.POS_ACC_INV_VOID_ORD_ID);
       * //InvVoidS.AccInvVoidSubOrderID = 0;
       * ordVoidSubMap.put("ordVoidSubBillId", getAccMap.get("accBillId"));
       * //InvVoidS.AccInvVoidSubBillID = accorderbill.AccBillID;
       * ordVoidSubMap.put("ordVoidSubBillAmt", params.get("rePosTotAmt"));
       * //ACC_INV_VOID_SUB_BILL_AMT InvVoidS.AccInvVoidSubBillAmt =
       * decimal.Parse(totalcharges); ordVoidSubMap.put("ordVoidSubCrditNote",
       * cnno); //ACC_INV_VOID_SUB_CRDIT_NOTE //
       * InvVoidS.AccInvVoidSubCreditNote = InvAdjM.MemoAdjustRefNo;
       * ordVoidSubMap.put("ordVoidSubCrditNoteId", memoAdjSeq);
       * //InvVoidS.AccInvVoidSubCreditNoteID = InvAdjM.MemoAdjustID; String
       * voidSubRem= String.valueOf(params.get("rePosNo"));
       * ordVoidSubMap.put("ordVoidSubRem",
       * SalesConstants.POS_REM_SOI_COMMENT_INV_VOID + voidSubRem);
       *
       * LOGGER.info(
       * "############### 11. POS ACC ORDER VOID INVOICE SUB REVERSAL INSERT START  ################"
       * ); LOGGER.info(
       * "############### 11. POS ACC ORDER VOID INVOICE SUB REVERSAL INSERT PARAM : "
       * + ordVoidSubMap.toString());
       * posMapper.insertAccOrderVoidInvSub(ordVoidSubMap); LOGGER.info(
       * "############### 11. POS ACC ORDER VOID INVOICE SUB REVERSAL INSERT END  ################"
       * );
       */
    } // taxInvMap not null (miscM)

    // 12.
    // *********************************************************************************************************
    // STOCK RECORD CARD
    if (SalesConstants.POS_SALES_TYPE_FILTER.equals(String.valueOf(params.get("rePosSysTypeId")))) { // 1352
                                                                                                     // filter
                                                                                                     // &
                                                                                                     // spare
                                                                                                     // part
      Map<String, Object> stkMap = new HashMap<String, Object>();
      List<EgovMap> stkList = null;

      stkMap.put("rePosNo", params.get("rePosNo"));
      stkList = posMapper.selectStkCardRecordList(stkMap);

      if (stkList != null && stkList.size() > 0) {
        for (int idx = 0; idx < stkList.size(); idx++) {
          EgovMap reStkMap = null;
          reStkMap = stkList.get(idx);

          stkSeq = posMapper.getSeqLog0014D();

          reStkMap.put("stkSeq", stkSeq);
          reStkMap.put("posRefNo", posRefNo); // irc.RefNo = posRefNo;

          int stkTempQty = Integer.parseInt(String.valueOf(reStkMap.get("qty")));
          stkTempQty = -1 * stkTempQty;
          reStkMap.put("stkTempQty", stkTempQty); // irc.Qty = -1 * irc.Qty;

          reStkMap.put("stkRem", SalesConstants.POS_REM_SOI_COMMENT_INV_VOID + String.valueOf(params.get("rePosNo")));

          LOGGER
              .info("############### 12 - [" + idx + "] POS STOCK RECORD CARD REVERSAL INSERT START  ################");
          LOGGER.info("############### 12 - [" + idx + "] POS STOCK RECORD CARD REVERSAL INSERT PARAM : "
              + reStkMap.toString());
          posMapper.insertStkCardRecordReversal(reStkMap);
          LOGGER.info("############### 12 - [" + idx + "] POS STOCK RECORD CARD REVERSAL INSERT END  ################");

        }
      }
    }

    // Old_POSPayID
    // LOGGER.info("###################### IS PAYED ?(More Than '0' is Payed ) =
    // " + params.get("rePayId"));
    // String trxNo = "";
    // String rorNo = "";
    // if(Integer.parseInt(String.valueOf(params.get("rePayId"))) > 0){
    /***************** Params Setting And Get Doc No ********************/
    // params.put("docNoId", SalesConstants.POS_DOC_NO_TRX_NO); //DOC(23)
    // trxNo = posMapper.getDocNo(params); //23
    // params.put("docNoId", SalesConstants.POS_DOC_ROR_NO); //DOC(82)
    // rorNo = posMapper.getDocNo(params);

    // 13.
    // *********************************************************************************************************
    // Reverse Pay M
    // Get Pay M Info
    // EgovMap payInfoMap = null;
    // int payMseq = 0;
    // payInfoMap = posMapper.getPayInfoByPayId(params);
    // Map<String, Object> rePaymMap = new HashMap<String, Object>();

    /*
     * if(payInfoMap != null){
     *
     *
     * payMseq = posMapper.getSeqPay0064D(); rePaymMap.put("payMseq", payMseq);
     * rePaymMap.put("orNo", rorNo); //doc(82) rePaymMap.put("salesOrdId",
     * Integer.parseInt(String.valueOf(payInfoMap.get("salesOrdId"))));
     * rePaymMap.put("billId", posBillSeq); rePaymMap.put("trNo",
     * payInfoMap.get("trNo")); rePaymMap.put("typeId",
     * SalesConstants.POS_PAY_REVERSE_TYPE); rePaymMap.put("bankChgAmt",
     * Integer.parseInt(String.valueOf(payInfoMap.get("bankChgAmt"))));
     * rePaymMap.put("bankChgAccId",
     * Integer.parseInt(String.valueOf(payInfoMap.get("bankChgAccId"))));
     * rePaymMap.put("collMemId",
     * Integer.parseInt(String.valueOf(payInfoMap.get("collMemId"))));
     * rePaymMap.put("brnchId",
     * Integer.parseInt(String.valueOf(payInfoMap.get("brnchId"))));
     * rePaymMap.put("bankAccId",
     * Integer.parseInt(String.valueOf(payInfoMap.get("bankAccId"))));
     * rePaymMap.put("allowComm",
     * Integer.parseInt(String.valueOf(payInfoMap.get("allowComm"))));
     * rePaymMap.put("stusCodeId",
     * Integer.parseInt(String.valueOf(payInfoMap.get("stusCodeId"))));
     * rePaymMap.put("updUserId", params.get("userId"));
     * rePaymMap.put("syncCheck",
     * Integer.parseInt(String.valueOf(payInfoMap.get("syncHeck"))));
     * rePaymMap.put("thirdPartyCustId",
     * Integer.parseInt(String.valueOf(payInfoMap.get("custId3party"))));
     * //rePaymMap.put("totAmt",
     * -1*Double.parseDouble(String.valueOf(payInfoMap.get("totAmt"))));
     * rePaymMap.put("totAmt", rtnAmt); rePaymMap.put("matchId",
     * Integer.parseInt(String.valueOf(payInfoMap.get("mtchId"))));
     * rePaymMap.put("crtUserId", params.get("userId"));
     * rePaymMap.put("isAllowRevMulti",
     * Integer.parseInt(String.valueOf(payInfoMap.get("isAllowRevMulti"))));
     * rePaymMap.put("isGlPostClm",
     * Integer.parseInt(String.valueOf(payInfoMap.get("isGlPostClm"))));
     * rePaymMap.put("glPostClmDt",
     * String.valueOf(payInfoMap.get("glPostClmDt"))); rePaymMap.put("trxSeq",
     * Integer.parseInt(String.valueOf(payInfoMap.get("trxId"))));
     * rePaymMap.put("advMonth",
     * Integer.parseInt(String.valueOf(payInfoMap.get("advMonth"))));
     * rePaymMap.put("orderBillId",
     * Integer.parseInt(String.valueOf(payInfoMap.get("accBillId"))));
     * rePaymMap.put("trIssuDt", payInfoMap.get("trIssuDt"));//
     * rePaymMap.put("payInvIsGen",
     * Integer.parseInt(String.valueOf(payInfoMap.get("taxInvcIsGen"))));
     * rePaymMap.put("taxInvcRefNo",
     * String.valueOf(payInfoMap.get("taxInvcRefNo")));
     * rePaymMap.put("taxInvcRefDt",
     * String.valueOf(payInfoMap.get("taxInvcRefDt")));//
     * rePaymMap.put("svcCntrctId",
     * Integer.parseInt(String.valueOf(payInfoMap.get("svcCntrctId"))));
     * rePaymMap.put("batchPayId", payInfoMap.get("batchPayId"));
     *
     * LOGGER.info(
     * "############### 13. POS Reverse Pay M INSERT START  ################");
     * LOGGER.info("############### 13. POS Reverse Pay M INSERT PARAM   : " +
     * rePaymMap.toString()); posMapper.insertRePayMaster(rePaymMap);
     * LOGGER.info(
     * "############### 13. POS Reverse Pay M INSERT END  ################");
     *
     * }
     */

    // 14.
    // *********************************************************************************************************
    // Reverse Pay X
    /*
     * params.put("trxId", payInfoMap.get("trxId"));
     *
     * EgovMap getTrxInfoMap = null; getTrxInfoMap =
     * posMapper.getTrxInfo(params);
     *
     * Map<String, Object> rePayxMap = new HashMap<String, Object>();
     * Map<String, Object> updPaymMap = new HashMap<String, Object>();
     *
     * int payXseq = posMapper.getSeqPay0069D(); groupSeq =
     * posMapper.getSeqPay0240T(); // add by lee (2018-01-25)
     *
     * if(getTrxInfoMap != null){
     *
     * rePayxMap.put("trxSeq", payXseq); rePayxMap.put("trxType",
     * SalesConstants.POS_TRX_REVERSE_TYPE); // paytrx.TrxType = 101;
     * //rePayxMap.put("trxAmt",
     * -1*Double.parseDouble(String.valueOf(getTrxInfoMap.get("trxAmt")))); //
     * paytrx.TrxAmount = -1 * paytrx.TrxAmount; rePayxMap.put("trxAmt",
     * rtnAmt); // paytrx.TrxAmount = -1 * paytrx.TrxAmount;
     * rePayxMap.put("trxMatchNo", getTrxInfoMap.get("trxMtchNo"));
     *
     * LOGGER.info(
     * "############### 14. POS Reverse Pay X INSERT START  ################");
     * LOGGER.info("############### 14. POS Reverse Pay X INSERT PARAM   : " +
     * rePayxMap.toString()); posMapper.insertRePayTrx(rePayxMap); LOGGER.info(
     * "############### 14. POS Reverse Pay X INSERT END  ################");
     */
    // 15.
    // *********************************************************************************************************
    // Update Pay Master.trxId

    /*
     * updPaymMap.put("payId", payMseq); updPaymMap.put("trxId", payXseq);
     *
     * LOGGER.info(
     * "############### 15. POS Update Pay Master.trxId UPDATE START  ################"
     * ); LOGGER.info(
     * "############### 15. POS Update Pay Master.trxId UPDATE PARAM   : " +
     * updPaymMap.toString()); posMapper.updatePayMTrxId(updPaymMap);
     * LOGGER.info(
     * "############### 15. POS Update Pay Master.trxId UPDATE END  ################"
     * ); }
     */
    /* Pay Detail And AccGLRoute */
    // Detail List (Info)
    // List<EgovMap> rePayDList = null;
    // rePayDList = posMapper.getPayDetailListByPayId(params);

    // if(rePayDList != null && rePayDList.size() > 0){

    // LOOP Start
    // for (int idx = 0; idx < rePayDList.size(); idx++) {

    // 16.
    // *********************************************************************************************************
    // Reverse Pay D
    // EgovMap rePayMap = rePayDList.get(idx);
    /* Pay D */
    /*
     * Map<String, Object> paydMap = new HashMap<String, Object>(); int payDseq
     * = posMapper.getSeqPay0065D();
     *
     * paydMap.put("payItemId", payDseq); paydMap.put("payId", payMseq);
     * //payd.PayID = payM.PayID; paydMap.put("payMode",
     * Integer.parseInt(String.valueOf(rePayMap.get("payItmModeId"))));
     * paydMap.put("transactionRefNo", rePayMap.get("payItmRefNo"));
     * paydMap.put("payCreditCardNo", rePayMap.get("payItmCcNo"));
     * paydMap.put("payCreditCardOriNo", rePayMap.get("payItmOriCcNo"));
     * paydMap.put("payCreditCardEncryptNo", rePayMap.get("payItmEncryptCcNo"));
     * paydMap.put("payCrcType", rePayMap.get("payItmCcTypeId"));
     * paydMap.put("payItmChqNo", rePayMap.get("payItmChqNo"));
     * paydMap.put("payIssueBank", rePayMap.get("payItmIssuBankId"));
     * paydMap.put("payAmt",
     * -1*Double.parseDouble(String.valueOf(rePayMap.get("payItmAmt"))));
     * //PAY_ITM_AMT, payd.PayItemAmt = -1 * payd.PayItemAmt;
     * paydMap.put("payCrcMode", rePayMap.get("payItmIsOnline"));
     * paydMap.put("payBankAccount", rePayMap.get("payItmBankAccId"));
     * paydMap.put("payRefDate", rePayMap.get("payItmRefDt"));
     * paydMap.put("payApprovNo", rePayMap.get("payItmAppvNo"));
     * paydMap.put("payRem", SalesConstants.POS_PAY_ITEM_REMARK_REVERSAL +
     * String.valueOf(params.get("rePosNo"))); //payd.PayitemRemark =
     * "SOI Reversal - " + Old_POSNo; paydMap.put("payItmStusId",
     * rePayMap.get("payItmStusId")); paydMap.put("payItmIsLok",
     * rePayMap.get("payItmIsLok")); paydMap.put("payItmCcHolderName",
     * rePayMap.get("payItmCcHolderName")); paydMap.put("payItmCcExprDt",
     * rePayMap.get("payItmCcExprDt")); paydMap.put("payItmBankChrgAmt",
     * -1*Double.parseDouble(String.valueOf(rePayMap.get("payItmBankChrgAmt"))))
     * ; // payd.PayItemBankChargeAmt = -1 * payd.PayItemBankChargeAmt;
     * paydMap.put("payItmIsThirdParty", rePayMap.get("payItmIsThrdParty"));
     * paydMap.put("payItmThrdPartyIc", rePayMap.get("payItmThrdPartyIc"));
     * paydMap.put("payItmBankBrnchId", rePayMap.get("payItmBankBrnchId"));
     * paydMap.put("payItmBankInSlipNo", rePayMap.get("payItmBankInSlipNo"));
     * paydMap.put("payItmEftNo", rePayMap.get("payItmEftNo"));
     * paydMap.put("payItmChqDepReciptNo",
     * rePayMap.get("payItmChqDepReciptNo")); paydMap.put("etc1",
     * rePayMap.get("etc1")); paydMap.put("etc2", rePayMap.get("etc2"));
     * paydMap.put("etc3", rePayMap.get("etc3")); paydMap.put("payItmMid",
     * rePayMap.get("payItmMid")); paydMap.put("payItmGrpId",
     * rePayMap.get("payItmGrpId")); paydMap.put("payItmRefItmId",
     * rePayMap.get("payItmId")); // payd.PayItemRefItemID = payd.PayItemID;
     * paydMap.put("payItmBankChrgAccId", rePayMap.get("payItmBankChrgAccId"));
     * paydMap.put("payItmRunngNo", rePayMap.get("payItmRunngNo"));
     * paydMap.put("updUserId", params.get("userId"));
     * paydMap.put("isFundTrnsfr", rePayMap.get("isFundTrnsfr"));
     * paydMap.put("skipRecon", rePayMap.get("skipRecon"));
     * paydMap.put("payItmCardTypeId", rePayMap.get("payItmCardTypeId"));
     * paydMap.put("payItmCardModeId", rePayMap.get("payItmCardModeId"));
     *
     * LOGGER.info("############### 16 -["+idx+
     * "] POS Reverse Pay D INSERT START  ################"); LOGGER.info(
     * "############### 16 -["+idx+"] POS Reverse Pay D INSERT PARAM   : " +
     * paydMap.toString()); posMapper.insertRePayDetail(paydMap); LOGGER.info(
     * "############### 16 -["+idx+
     * "] POS Reverse Pay D INSERT END  ################");
     */
    // 17.
    // *********************************************************************************************************
    // Reverse AccGLRoute
    /* AccGlRoute */
    /*
     * EgovMap accGlRouteMap = null; Map<String, Object> accReMap = new
     * HashMap<String, Object>();
     *
     * params.put("payItmRefItmId", rePayMap.get("payItmId")); accGlRouteMap =
     * posMapper.getAccGLRoutesInfoByRcpItmId(params); //Basic
     *
     * int accGlRouteSeq = 0; accGlRouteSeq = posMapper.getSeqPay0009D();
     *
     *
     * if(accGlRouteMap != null){
     *
     *
     * accReMap.put("accGlRouteSeq", accGlRouteSeq); accReMap.put("glFiscalDt",
     * SalesConstants.DEFAULT_DATE); //route.GLFiscalDate =
     * DateTime.Parse(string.Format("{0:dd/MM/yyyy}", "1900-01-01"));
     * accReMap.put("glBatchNo", payXseq); //route.GLBatchNo =
     * paytrx.TrxID.ToString(); accReMap.put("glBatchTypeDesc", ""); //
     * route.GLBatchTypeDesc = ""; accReMap.put("glBatchTot", -1 *
     * Double.parseDouble(String.valueOf(accGlRouteMap.get("glBatchTot"))));
     * //route.GLBatchTotal = -1 * route.GLBatchTotal;
     * accReMap.put("glReciptNo", rorNo); //route.GLReceiptNo = payM.ORNo;
     * accReMap.put("glReciptType", SalesConstants.POS_GL_RECEIPT_REVERSE_TYPE);
     * //route.GLReceiptTypeID = 101; accReMap.put("glReciptBrnchId",
     * accGlRouteMap.get("glReciptBrnchId")); //route.GLReceiptBranchID =
     * route.GLReceiptBranchID; accReMap.put("glReciptSetlAccId",
     * accGlRouteMap.get("glReciptSetlAccId")); // route.GLReceiptSettleAccID =
     * route.GLReceiptSettleAccID; accReMap.put("glReciptAccId",
     * accGlRouteMap.get("glReciptAccId")); //route.GLReceiptAccountID =
     * route.GLReceiptAccountID; accReMap.put("glReciptItmId", payDseq);
     * //route.GLReceiptItemID = payd.PayItemID;
     * accReMap.put("glReciptItmModeId",
     * accGlRouteMap.get("glReciptItmModeId")); // route.GLReceiptItemModeID =
     * route.GLReceiptItemModeID; accReMap.put("glRevrsReciptItmId",
     * rePayMap.get("payItmId")); // route.GLReverseReceiptItemID =
     * (int)payd.PayItemRefItemID; accReMap.put("glReciptItmAmt", -1 *
     * Double.parseDouble(String.valueOf(accGlRouteMap.get("glReciptItmAmt"))));
     * //route.GLReceiptItemAmount = -1 * route.GLReceiptItemAmount;
     * accReMap.put("glReciptItmChrg", accGlRouteMap.get("glReciptItmChrg"));
     * //route.GLReceiptItemCharges = route.GLReceiptItemCharges;
     * accReMap.put("glReciptItmRclStus",
     * SalesConstants.POS_GL_RECEIPT_ITEM_RCL_STATUS); accReMap.put("glJrnlNo",
     * accGlRouteMap.get("glJrnlNo")); accReMap.put("glAuditRef",
     * accGlRouteMap.get("glAuditRef")); accReMap.put("glCnvrStus",
     * SalesConstants.POS_GL_CONVERSION_STATUS); accReMap.put("glCnvrDt",
     * accGlRouteMap.get("glCnvrDt"));
     *
     * LOGGER.info("############### 17 -["+idx+
     * "] POS Reverse AccGLRoute INSERT START  ################"); LOGGER.info(
     * "############### 17 -["+idx+"] POS Reverse AccGLRoute INSERT PARAM   : "
     * + accReMap.toString()); posMapper.insertReAccGlRoute(accReMap);
     * LOGGER.info("############### 17 -["+idx+
     * "] POS Reverse AccGLRoute INSERT END  ################"); }
     *
     *//****** ADD LOGIC : INSERT PAY0252T // ADD BY LEE SH (2018/01/25) ****//*
                                                                              * Map
                                                                              * <
                                                                              * String,
                                                                              * Object>
                                                                              * payTMap
                                                                              * =
                                                                              * new
                                                                              * HashMap
                                                                              * <
                                                                              * String,
                                                                              * Object
                                                                              * >
                                                                              * (
                                                                              * )
                                                                              * ;
                                                                              *
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "groupSeq",
                                                                              * groupSeq
                                                                              * )
                                                                              * ;
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "prcssSeq",
                                                                              * idx
                                                                              * )
                                                                              * ;
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "trxId",
                                                                              * payXseq
                                                                              * )
                                                                              * ;
                                                                              * /
                                                                              * /
                                                                              * TRX
                                                                              * ID
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "payId",
                                                                              * payMseq
                                                                              * )
                                                                              * ;
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "payItmId",
                                                                              * payDseq
                                                                              * )
                                                                              * ;
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "payItmModeId",
                                                                              * paydMap
                                                                              * .
                                                                              * get
                                                                              * (
                                                                              * "payMode"
                                                                              * )
                                                                              * )
                                                                              * ;
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "totAmt",
                                                                              * rePaymMap
                                                                              * .
                                                                              * get
                                                                              * (
                                                                              * "totAmt"
                                                                              * )
                                                                              * )
                                                                              * ;
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "payItmAmt",
                                                                              * paydMap
                                                                              * .
                                                                              * get
                                                                              * (
                                                                              * "payAmt"
                                                                              * )
                                                                              * )
                                                                              * ;
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "bankChgAmt",
                                                                              * rePaymMap
                                                                              * .
                                                                              * get
                                                                              * (
                                                                              * "bankChgAmt"
                                                                              * )
                                                                              * )
                                                                              * ;
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "appType",
                                                                              * SalesConstants
                                                                              * .
                                                                              * POS_PAY_APP_TYPE
                                                                              * )
                                                                              * ;
                                                                              * /
                                                                              * /
                                                                              * POS
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "payRoute",
                                                                              * SalesConstants
                                                                              * .
                                                                              * POS_PAY_ROUTE
                                                                              * )
                                                                              * ;
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "payKeyinScrn",
                                                                              * SalesConstants
                                                                              * .
                                                                              * POS_PAY_KEY_IN_SCRN
                                                                              * )
                                                                              * ;
                                                                              * payTMap
                                                                              * .
                                                                              * put
                                                                              * (
                                                                              * "ldgrType",
                                                                              * SalesConstants
                                                                              * .
                                                                              * POS_PAY_LEDGER_TYPE
                                                                              * )
                                                                              * ;
                                                                              *
                                                                              * LOGGER
                                                                              * .
                                                                              * info(
                                                                              * "############### 17(2) -["
                                                                              * +idx+
                                                                              * "]. POS PAYT INSERT START  ################"
                                                                              * );
                                                                              * LOGGER
                                                                              * .
                                                                              * info(
                                                                              * "############### 17(2) -["
                                                                              * +idx+
                                                                              * "]. POS PAYT INSERT param : "
                                                                              * +
                                                                              * payTMap
                                                                              * .
                                                                              * toString
                                                                              * (
                                                                              * )
                                                                              * )
                                                                              * ;
                                                                              * posMapper
                                                                              * .
                                                                              * insertPayT
                                                                              * (
                                                                              * payTMap
                                                                              * )
                                                                              * ;
                                                                              * LOGGER
                                                                              * .
                                                                              * info(
                                                                              * "############### 17(2) -["
                                                                              * +idx+
                                                                              * "]. POS PAYT INSERT END  ################"
                                                                              * );
                                                                              * }
                                                                              * /
                                                                              * /
                                                                              * LOOP
                                                                              * End
                                                                              *
                                                                              * }
                                                                              */
    // }// Pay Reverse

    // 18.
    // *********************************************************************************************************
    // GI Reverse

    // Request
    Map<String, Object> bookMap = new HashMap<String, Object>();

    bookMap.put("psno", posRefNo);
    bookMap.put("retype", "REQ");
    bookMap.put("pType", "PS02"); // PS02 - cancel
    bookMap.put("pPrgNm", "PointOfSales");
    bookMap.put("userId", Integer.parseInt(String.valueOf(params.get("userId"))));

    LOGGER.info("############### 18. POS Booking Reverse  START  ################");
    LOGGER.info("#########  call Procedure Params : " + bookMap.toString());
    posMapper.posBookingCallSP_LOGISTIC_POS(bookMap);
    reqResult = String.valueOf(bookMap.get("p1"));
    LOGGER.debug("############ Procedure Result :  " + reqResult);
    LOGGER.info("############### 18. POS Booking Reverse  END  ################");

    if (!"000".equals(reqResult)) { // Err
      return null;
    }

    // GetDetailList
    List<EgovMap> revDetList = null;
    bookMap.put("rcvStusId", SalesConstants.POS_DETAIL_NON_RECEIVE);
    revDetList = posMapper.getPosItmIdListByPosNo(bookMap);
    LOGGER.info("@@@@@@@@@@@@@@@@@@@@@@@@@@ revDetList : " + revDetList);
    for (int idx = 0; idx < revDetList.size(); idx++) {

      // GI Call Procedure
      Map<String, Object> giMap = new HashMap<String, Object>();

      giMap.put("psno", posRefNo);
      giMap.put("retype", "COM");
      giMap.put("pType", "PS01");
      giMap.put("posItmId", revDetList.get(idx).get("posItmId"));
      giMap.put("pPrgNm", "PointOfSales");
      giMap.put("userId", params.get("userId"));

      LOGGER.info("############### 19. POS GI Reverse  START  ################");
      LOGGER.info("#########  call Procedure Params : " + giMap.toString());
      posMapper.posGICallSP_LOGISTIC_POS(giMap);
      giResult = String.valueOf(giMap.get("p1"));
      LOGGER.info("@@@@@@@@@@@@@@@@@@@@@@@@@@ rtnResult : " + giResult);
      LOGGER.info("############### 19. POS GI Reverse  END  ################");

      if (!"000".equals(giResult)) { // Err
        return null;
      }
    }

    // Success
    EgovMap rtnMap = new EgovMap();
    rtnMap.put("posRefNo", posRefNo);
    // rtnMap.put("posWorNo", rorNo);
    return rtnMap;

  }

  @Override
  @Transactional
  public EgovMap insertPosReversalItemBank(Map<String, Object> params) throws Exception {

    /* ########### get Params ############### */
    double rtnAmt = 0;
    double rtnCharge = 0;
    double rtnTax = 0;
    double rtnDisc = 0;
    double tempBillAmt = 0;

    String posRefNo = ""; // SOI no. (144)
    String voidNo = ""; // Void no. (112)
    String rptNo = ""; // RD no. (18)
    String cnno = ""; // CN-New (134)

    int posMasterSeq = 0;
    int posDetailDuducSeq = 0;
    int posBillSeq = 0;
    int memoAdjSeq = 0;
    int noteSeq = 0;
    int miscSubSeq = 0;
    int noteSubSeq = 0;
    int ordVoidSeq = 0;
    int ordVoidSubSeq = 0;
    int stkSeq = 0;
    int groupSeq = 0;

    String giResult = "";
    String reqResult = "";

    /*
     * ################################### Get Doc No
     * #############################
     */

    params.put("docNoId", SalesConstants.POS_DOC_NO_PSN_NO); // (144)
    posRefNo = posMapper.getDocNo(params);

    params.put("docNoId", SalesConstants.POS_DOC_NO_VOID_NO); // (112)
    voidNo = posMapper.getDocNo(params);

    params.put("docNoId", SalesConstants.POS_DOC_NO_RD_NO); // (18)
    rptNo = posMapper.getDocNo(params);

    params.put("docNoId", SalesConstants.POS_DOC_NO_CN_NEW_NO); // (134)
    cnno = posMapper.getDocNo(params);

    // 1.
    // *********************************************************************************************************
    // POS MASTER

    // Price and Qty Setting

    rtnAmt = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotAmt")));
    rtnCharge = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotChrg")));
    rtnTax = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotTxs")));
    rtnDisc = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotDscnt")));

    // Seq
    posMasterSeq = posMapper.getSeqSal0057D(); // master Sequence
    Map<String, Object> posMap = new HashMap<String, Object>();

    posMap.put("posMasterSeq", posMasterSeq); // posId = 0 -- 시퀀스
    posMap.put("docNoPsn", posRefNo); // posNo = 0 --문서채번
    posMap.put("posBillId", SalesConstants.POS_BILL_ID); // pos Bill Id // 0

    posMap.put("posCustName", params.get("rePosCustName")); // posCustName =
                                                            // other Income만 사용함
                                                            // .. 그러면 나머지는??
    posMap.put("insPosModuleType", params.get("rePosModuleTypeId"));
    if (CommonUtils.nvl(params.get("reInd")).equals("2")) {
      posMap.put("insPosSystemType", SalesConstants.POS_SALES_TYPE_FLEXI_REVERSAL); // 5794
    } else {
      posMap.put("insPosSystemType", SalesConstants.POS_SALES_TYPE_REVERSAL); // 1361
    }
    posMap.put("posTotalAmt", rtnAmt);
    posMap.put("posCharge", rtnCharge);
    posMap.put("posTaxes", rtnTax);
    posMap.put("posDiscount", rtnDisc);
    posMap.put("hidLocId", params.get("rePosWhId"));
    posMap.put("posRemark", params.get("reversalRem"));
    posMap.put("posMtchId", params.get("rePosId")); // pos Old ID
    posMap.put("salesmanPopId", params.get("rePosMemId"));
    posMap.put("posCustomerId", SalesConstants.POS_CUST_ID); // 107205
    posMap.put("userId", params.get("userId"));

    /*
     * if(params.get("userDeptId") == null){ params.put("userDeptId", 0); }
     * posMap.put("userDeptId", params.get("userDeptId"));
     */
    posMap.put("userDeptId", 0);
    if (params.get("userDeptId") == null) {
      params.put("userDeptCode", " ");
    }
    posMap.put("userDeptCode", params.get("userDeptId"));
    posMap.put("crAccId", params.get("rePosCrAccId"));
    posMap.put("drAccId", params.get("rePosDrAccId"));
    posMap.put("posReason", params.get("rePosResnId"));
    posMap.put("cmbWhBrnchIdPop", params.get("rePosBrnchId")); // Brnch
    posMap.put("recvDate", params.get("rePosRcvDt"));
    posMap.put("posStusId", params.get("rePosStusId"));

    if (params.get("rePosModuleTypeId").equals(SalesConstants.POS_SALES_MODULE_TYPE_OTH)) {
      posMap.put("chkOth", SalesConstants.POS_OTH_CHECK_PARAM);
      posMap.put("getAreaId", params.get("getAreaId"));
      posMap.put("addrDtl", params.get("addrDtl"));
      posMap.put("streetDtl", params.get("streetDtl"));
    }

    // Pos Master Insert
    LOGGER.info("############### 1. POS MASTER REVERSAL INSERT START  ################");
    LOGGER.info("############### 1. POS MASTER REVERSAL INSERT param : " + posMap.toString());
    posMapper.insertPosReversalMaster(posMap);
    LOGGER.info("############### 1. POS MASTER REVERSAL INSERT END  ################");

    // 2.
    // *********************************************************************************************************
    // POS DETAIL

    List<EgovMap> oldDetailList = null;
    oldDetailList = posMapper.getOldDetailList(params); // Old Pos Id == param
    // old pos id 로 디테일 리스트 불러옴
    if (oldDetailList != null && oldDetailList.size() > 0) { // for (old List)

      for (int idx = 0; idx < oldDetailList.size(); idx++) {

        EgovMap revDetailMap = null;
        double tempTot = 0;
        double tempChrg = 0;
        double tempTxs = 0;
        int tempQty = 0;

        revDetailMap = oldDetailList.get(idx); // map 생성 --parameter // params
                                               // setting >> old List.get(i) >>
                                               // Map 에 put

        posDetailDuducSeq = posMapper.getSeqSal0058D(); // detail Sequence

        // detail 생성 ....
        revDetailMap.put("posDetailDuducSeq", posDetailDuducSeq); // seq
        revDetailMap.put("posMasterSeq", posMasterSeq); // master Seq

        tempQty = Integer.parseInt(String.valueOf(revDetailMap.get("posItmQty")));
        tempQty = -1 * tempQty;
        revDetailMap.put("posDetailQty", tempQty);

        tempTot = Double.parseDouble(String.valueOf(revDetailMap.get("posItmTot")));
        tempTot = -1 * tempTot;
        revDetailMap.put("posDetailTotal", tempTot);

        tempChrg = Double.parseDouble(String.valueOf(revDetailMap.get("posItmChrg")));
        tempChrg = -1 * tempChrg;
        revDetailMap.put("posDetailCharge", tempChrg);

        tempTxs = Double.parseDouble(String.valueOf(revDetailMap.get("posItmTxs")));
        tempTxs = -1 * tempTxs;
        revDetailMap.put("posDetailTaxs", tempTxs);

        revDetailMap.put("posRcvStusId", SalesConstants.POS_DETAIL_NON_RECEIVE); // RCV_STUS_ID
                                                                                 // ==
                                                                                 // 96
                                                                                 // (Non
                                                                                 // Receive)
        revDetailMap.put("userId", params.get("userId"));

        revDetailMap.put("locId", params.get("rePosBrnchId"));

        if (revDetailMap != null) {
          LOGGER.info("############### 2 - [" + idx + "]  POS DETAIL REVERSAL INSERT START  ################");
          LOGGER
              .info("############### 2 - [" + idx + "]  POS DETAIL REVERSAL INSERT param : " + revDetailMap.toString());
          posMapper.insertPosReversalDetail(revDetailMap);

          if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_REVERSAL))
            posMapper.updateLOG0106MDetail(revDetailMap);

          LOGGER.info("############### 2 - [" + idx + "]  POS DETAIL REVERSAL INSERT END  ################");
        }
      }
      // 2 - 1 .
      // *********************************************************************************************************
      // POS DETAIL
      List<EgovMap> oldSerialList = null;
      oldSerialList = posMapper.chkOldReqSerial(params);

      if (oldSerialList != null && oldSerialList.size() > 0) {
        // Serial Insert
        for (int idx = 0; idx < oldSerialList.size(); idx++) {
          int serialSeq = posMapper.getSeqSal0147M();
          EgovMap oldSerialMap = oldSerialList.get(idx);

          Map<String, Object> serialMap = new HashMap<String, Object>();

          serialMap.put("serialSeq", serialSeq);
          serialMap.put("posMasterSeq", posMasterSeq);
          serialMap.put("stkId", oldSerialMap.get("posItmStockId")); // POS_ITM_STOCK_ID
          serialMap.put("serialNo", oldSerialMap.get("posSerialNo")); // POS_SERIAL_NO
          serialMap.put("userId", params.get("userId"));

          LOGGER.info("############### 2 - Serial - " + idx + "  POS SERIAL INSERT START  ################");
          LOGGER.info("############### 2 - Serial - " + idx + "  POS SERIAL INSERT param : " + serialMap.toString());
          posMapper.insertSerialNo(serialMap);
          LOGGER.info("############### 2 - Serial - " + idx + "  POS SERIAL INSERT END  ################");

        }
      }
    }

    EgovMap billInfoMap = null;
    billInfoMap = posMapper.getBillInfo(params);

    if (billInfoMap != null) {
      // 3.
      // *********************************************************************************************************
      // ACC BILLING
      tempBillAmt = Double.parseDouble(String.valueOf(billInfoMap.get("billAmt")));
      tempBillAmt = -1 * tempBillAmt;

      posBillSeq = posMapper.getSeqPay0007D(); // seq

      billInfoMap.put("billAmt", tempBillAmt);
      billInfoMap.put("posBillSeq", posBillSeq);
      billInfoMap.put("docNoPsn", posRefNo); // posNo = 0 --문서채번
      billInfoMap.put("userId", params.get("userId"));

      // insert
      LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE START  ################");
      LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE PARAM : " + billInfoMap.toString());
      posMapper.insertPosReversalBilling(billInfoMap);
      LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE END  ################");
      // 4.
      // *********************************************************************************************************
      // POS MASTER UPDATE BILL_ID
      // posMaster 의 만들어진 시퀀스 번호가 조건일때 posBillId == accBilling 의 시퀀스 ()
      Map<String, Object> posUpMap = new HashMap<String, Object>();
      posUpMap.put("posBillSeq", posBillSeq);
      posUpMap.put("posMasterSeq", posMasterSeq);
      LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER START  ################");
      LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER param : " + posUpMap.toString());
      posMapper.updatePosMasterPosBillId(posUpMap);
      LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER END  ################");

    }

    EgovMap taxInvMap = null;
    EgovMap getAccMap = null;
    taxInvMap = posMapper.getTaxInvoiceMisc(params); // PAY0031D miscM //
                                                     // MISC(M) MASTER

    if (taxInvMap != null) {
      // 5.
      // *********************************************************************************************************
      // ACC ORDER BILL
      Map<String, Object> accInfoMap = new HashMap<String, Object>();
      accInfoMap.put("taxInvcRefNo", taxInvMap.get("taxInvcRefNo"));

      getAccMap = posMapper.getAccOrderBill(accInfoMap); // 인서트 칠 인포메이션
                                                         // ACC_BILL_ID //

      if (getAccMap != null) {

        Map<String, Object> accOrdUpMap = new HashMap<String, Object>();

        accOrdUpMap.put("accBillId", getAccMap.get("accBillId"));
        accOrdUpMap.put("accBillStatus", SalesConstants.POS_ACC_BILL_STATUS); // 74
        accOrdUpMap.put("accBillTaskId", SalesConstants.POS_ACC_BILL_TASK_ID);

        LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE START  ################");
        LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE PARAM  : " + accOrdUpMap.toString());
        posMapper.updateAccOrderBillingWithPosReversal(accOrdUpMap);
        LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE END  ################");
      }
      // 6.
      // *********************************************************************************************************
      // INVOICE ADJUSTMENT (MASTER)

      Map<String, Object> adjMap = new HashMap<String, Object>();

      memoAdjSeq = posMapper.getSeqPay0011D();

      adjMap.put("memoAdjSeq", memoAdjSeq);
      adjMap.put("memoAdjRefNo", cnno); // 134 //InvAdjM.MemoAdjustRefNo = "";
                                        // //update later
      adjMap.put("memoAdjReptNo", rptNo); // 18 //InvAdjM.MemoAdjustReportNo =
                                          // ""; //update later
      adjMap.put("memoAdjTypeId", SalesConstants.POS_INV_ADJM_MEMO_TYPE_ID); // InvAdjM.MemoAdjustTypeID
                                                                             // =
                                                                             // 1293;
                                                                             // //Type
                                                                             // -
                                                                             // CN
      adjMap.put("memoAdjInvNo", taxInvMap.get("taxInvcRefNo")); // TAX_INVC_REF_NO
                                                                 // InvAdjM.MemoAdjustInvoiceNo
                                                                 // = "";
                                                                 // //update
                                                                 // later-InvoiceNo
                                                                 // BR68..
      adjMap.put("memoAdjInvTypeId", SalesConstants.POS_INV_ADJM_MEMO_INVOICE_TYPE_ID); // InvAdjM.MemoAdjustInvoiceTypeID
                                                                                        // =
                                                                                        // 128;
                                                                                        // //
                                                                                        // Invoice-Miscellaneous
      adjMap.put("memoAdjStatusId", SalesConstants.POS_INV_ADJM_MEMO_STATUS_ID); // InvAdjM.MemoAdjustStatusID
                                                                                 // =
                                                                                 // 4;
      adjMap.put("memoAdjReasonId", SalesConstants.POS_INV_ADJM_MEMO_RESN_ID); // InvAdjM.MemoAdjustReasonID
                                                                               // =
                                                                               // 2038;
                                                                               // //
                                                                               // Invoice
                                                                               // Reversal
      adjMap.put("memoAdjRem", params.get("reversalRem")); // rem
                                                           // InvAdjM.MemoAdjustRemark
                                                           // =
                                                           // this.txtReversalRemark.Text.Trim();
      adjMap.put("memoAdjTotTxs", taxInvMap.get("taxInvcTxs")); // TAX_INVC_TXS
                                                                // InvAdjM.MemoAdjustTaxesAmount
                                                                // =
                                                                // miscM.TaxInvoiceTaxes;
      adjMap.put("memoAdjTotAmt", taxInvMap.get("taxInvcAmtDue")); // TAX_INVC_AMT_DUE
                                                                   // InvAdjM.MemoAdjustTotalAmount
                                                                   // =
                                                                   // miscM.TaxInvoiceAmountDue;
      adjMap.put("userId", params.get("userId"));

      // insert
      LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT START  ################");
      LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT PARAM : " + adjMap.toString());
      posMapper.insertInvAdjMemo(adjMap);
      LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT END  ################");

      // 7.
      // *********************************************************************************************************
      // ACC TAX DEBIT CREDIT NOTE

      Map<String, Object> noteMap = new HashMap<String, Object>();

      noteSeq = posMapper.getSeqPay0027D();

      noteMap.put("noteSeq", noteSeq); // seq
      noteMap.put("memoAdjSeq", memoAdjSeq); // dcnM.NoteEntryID =
                                             // InvAdjM.MemoAdjustID;
      noteMap.put("noteTypeId", SalesConstants.POS_NOTE_TYPE_ID); // dcnM.NoteTypeID
                                                                  // = 1293;
                                                                  // //CN
      noteMap.put("noteGrpNo", taxInvMap.get("taxInvcSvcNo")); // dcnM.NoteGroupNo
                                                               // =
                                                               // miscM.TaxInvoiceServiceNo;
                                                               // TAX_INVC_SVC_NO
      noteMap.put("noteRefNo", cnno); // dcnM.NoteRefNo =
                                      // InvAdjM.MemoAdjustRefNo;
      noteMap.put("noteRefDate", taxInvMap.get("taxInvcRefDt")); // TAX_INVC_REF_DT
                                                                 // //dcnM.NoteRefDate
                                                                 // =
                                                                 // miscM.TaxInvoiceRefDate;
      noteMap.put("noteInvNo", taxInvMap.get("taxInvcRefNo")); // dcnM.NoteInvoiceNo
                                                               // =
                                                               // InvAdjM.MemoAdjustInvoiceNo;
      noteMap.put("noteInvTypeId", SalesConstants.POS_NOTE_INVOICE_TYPE_ID); // dcnM.NoteInvoiceTypeID
                                                                             // =
                                                                             // 128;
                                                                             // //MISC
      noteMap.put("noteInvCustName", taxInvMap.get("taxInvcCustName")); // dcnM.NoteCustName
                                                                        // =
                                                                        // miscM.TaxInvoiceCustName;
                                                                        // //TAX_INVC_CUST_NAME,
      noteMap.put("noteCntcPerson", taxInvMap.get("taxInvcCntcPerson")); // dcnM.NoteContatcPerson
                                                                         // =
                                                                         // miscM.TaxInvoiceContactPerson;
                                                                         // //TAX_INVC_CNTC_PERSON,
      /*
       * dcnM.NoteAddress1 = miscM.TaxInvoiceAddress1; dcnM.NoteAddress2 =
       * miscM.TaxInvoiceAddress2; dcnM.NoteAddress3 = miscM.TaxInvoiceAddress3;
       * dcnM.NoteAddress4 = miscM.TaxInvoiceAddress4; dcnM.NotePostCode =
       * miscM.TaxInvoicePostCode; dcnM.NoteAreaName = ""; dcnM.NoteStateName =
       * miscM.TaxInvoiceStateName; dcnM.NoteCountryName =
       * miscM.TaxInvoiceCountry;
       */
      noteMap.put("noteInvTxs", taxInvMap.get("taxInvcTxs")); // dcnM.NoteTaxes
                                                              // =
                                                              // miscM.TaxInvoiceTaxes;
      noteMap.put("noteInvChrg", taxInvMap.get("taxInvcChrg")); // dcnM.NoteCharges
                                                                // =
                                                                // miscM.TaxInvoiceCharges;
                                                                // //
                                                                // TAX_INVC_CHRG,
      noteMap.put("noteInvAmt", taxInvMap.get("taxInvcAmtDue")); // dcnM.NoteAmountDue
                                                                 // =
                                                                 // miscM.TaxInvoiceAmountDue;

      String soRem = String.valueOf(taxInvMap.get("taxInvcSvcNo"));
      noteMap.put("noteRem", SalesConstants.POS_REM_SOI_COMMENT + soRem); // dcnM.NoteRemark
                                                                          // =
                                                                          // "SOI
                                                                          // Reversal
                                                                          // - "
                                                                          // +
                                                                          // miscM.TaxInvoiceServiceNo;
      noteMap.put("noteStatusId", SalesConstants.POS_NOTE_STATUS_ID); // dcnM.NoteStatusID
                                                                      // = 4;
      noteMap.put("userId", params.get("userId"));

      LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT START  ################");
      LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT PARAM :  " + noteMap.toString());
      posMapper.insertTaxDebitCreditNote(noteMap);
      LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT END  ################");

      Map<String, Object> miscSubMap = new HashMap<String, Object>();
      miscSubMap.put("taxInvcId", taxInvMap.get("taxInvcId"));
      List<EgovMap> miscSubList = null;
      miscSubList = posMapper.getMiscSubList(miscSubMap);

      if (null != miscSubList && miscSubList.size() > 0) {

        for (int idx = 0; idx < miscSubList.size(); idx++) {
          // 8.
          // *********************************************************************************************************
          // INVOICE ADJUSTMENT SUB
          EgovMap tempSubMap = null;
          tempSubMap = miscSubList.get(idx);

          miscSubSeq = posMapper.getSeqPay0012D();
          Map<String, Object> accInvSubMap = new HashMap<String, Object>();
          accInvSubMap.put("miscSubSeq", miscSubSeq);
          accInvSubMap.put("memoAdjSeq", memoAdjSeq); // memoAdjSeq
          accInvSubMap.put("memoSubItmInvItmId", tempSubMap.get("invcItmId")); // INVC_ITM_ID
          accInvSubMap.put("memoSubItmInvItmQty", tempSubMap.get("invcItmQty")); // INVC_ITM_QTY

          accInvSubMap.put("memoSubItmCrditAccId", params.get("rePosCrAccId"));
          accInvSubMap.put("memoSubItmDebtAccId", params.get("rePosDrAccId"));
          accInvSubMap.put("memoSubItmTaxCodeId", getAccMap.get("accBillTaxCodeId"));
          accInvSubMap.put("memoSubItmStusId", SalesConstants.POS_MEMO_ITM_STATUS_ID); // 1
          accInvSubMap.put("memoSubItmRem", params.get("reversalRem")); //// InvAdjM.MemoAdjustRemark;

          accInvSubMap.put("memoSubItmInvItmGSTRate", tempSubMap.get("invcItmGstRate")); // INVC_ITM_GST_RATE
          accInvSubMap.put("memoSubItmInvItmCharges", tempSubMap.get("invcItmChrg")); // INVC_ITM_CHRG
          accInvSubMap.put("memoSubItmInvItmTaxes", tempSubMap.get("invcItmGstTxs")); // INVC_ITM_GST_TXS
          accInvSubMap.put("memoSubItmInvItmAmount", tempSubMap.get("invcItmAmtDue")); // INVC_ITM_AMT_DUE

          LOGGER.info(
              "############### 8 - [" + idx + "] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT START  ################");
          LOGGER.info("############### 8 - [" + idx + "] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT PARAM : "
              + accInvSubMap.toString());
          posMapper.insertInvAdjMemoSub(accInvSubMap);
          LOGGER.info(
              "############### 8 - [" + idx + "] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT END  ################");

          // 9.
          // *********************************************************************************************************
          // ACC TAX DEBIT CREDIT NOTE SUB

          Map<String, Object> noteSubMap = new HashMap<String, Object>();
          noteSubSeq = posMapper.getSeqPay0028D();

          noteSubMap.put("noteSubSeq", noteSubSeq);
          noteSubMap.put("noteSeq", noteSeq); // dcnS.NoteID = dcnM.NoteID;
          noteSubMap.put("noteSubItmId", tempSubMap.get("invcItmId")); // dcnS.NoteItemInvoiceItemID
                                                                       // =
                                                                       // miscSub.InvocieItemID;
          noteSubMap.put("noteSubOrdNo", tempSubMap.get("invcItmOrdNo")); // dcnS.NoteItemOrderNo
                                                                          // =
                                                                          // miscSub.InvoiceItemOrderNo;
          noteSubMap.put("noteSubItmProductModel", tempSubMap.get("invcItmDesc1")); // dcnS.NoteItemProductModel
                                                                                    // =
                                                                                    // miscSub.InvoiceItemDescription1;
          noteSubMap.put("noteSubItmSerialNo", tempSubMap.get("invcItmSerialNo")); // dcnS.NoteItemSerialNo
                                                                                   // =
                                                                                   // miscSub.InvoiceItemSerialNo;
          noteSubMap.put("noteSubItmInstDt", tempSubMap.get("invcItmInstallDt")); // dcnS.NoteItemInstallationDate
                                                                                  // =
                                                                                  // miscSub.InvoiceItemInstallDate;
          /*
           * dcnS.NoteItemAdd1 = miscSub.InvoiceItemAdd1; dcnS.NoteItemAdd2 =
           * miscSub.InvoiceItemAdd2; dcnS.NoteItemAdd3 =
           * miscSub.InvoiceItemAdd3; dcnS.NoteItemAdd4 =
           * miscSub.InvoiceItemAdd4; dcnS.NoteItemPostcode =
           * miscSub.InvoiceItemPostCode; dcnS.NoteItemAreaName =
           * miscSub.InvoiceItemAreaName; dcnS.NoteItemStateName =
           * miscSub.InvoiceItemStateName; dcnS.NoteItemCountry =
           * miscSub.InvoiceItemCountry;
           */
          noteSubMap.put("noteSubItmQty", tempSubMap.get("invcItmQty")); // dcnS.NoteItemQuantity
                                                                         // =
                                                                         // miscSub.InvoiceItemQuantity;
          noteSubMap.put("noteSubItmUnitPrc", tempSubMap.get("invcItmUnitPrc")); // dcnS.NoteItemUnitPrice
                                                                                 // =
                                                                                 // miscSub.InvoiceItemUnitPrice;
          noteSubMap.put("noteSubItmGstRate", tempSubMap.get("invcItmGstRate")); // dcnS.NoteItemGSTRate
                                                                                 // =
                                                                                 // miscSub.InvoiceItemGSTRate;
          noteSubMap.put("noteSubItmGstTxs", tempSubMap.get("invcItmGstTxs")); // dcnS.NoteItemGSTTaxes
                                                                               // =
                                                                               // miscSub.InvoiceItemGSTTaxes;
          noteSubMap.put("noteSubItmChrg", tempSubMap.get("invcItmChrg")); // dcnS.NoteItemCharges
                                                                           // =
                                                                           // miscSub.InvoiceItemCharges;
          noteSubMap.put("noteSubItmDueAmt", tempSubMap.get("invcItmAmtDue")); // dcnS.NoteItemDueAmount
                                                                               // =
                                                                               // miscSub.InvoiceItemAmountDue;

          LOGGER.info("############### 9 - [" + idx
              + "] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT START  ################");
          LOGGER.info("############### 9 - [" + idx + "] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT PARAM : "
              + noteSubMap.toString());
          posMapper.insertTaxDebitCreditNoteSub(noteSubMap);
          LOGGER.info("############### 9 - [" + idx
              + "] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT END  ################");
        }

      }

    } // taxInvMap not null (miscM)

    // 12.
    // *********************************************************************************************************
    // STOCK RECORD CARD
    if (SalesConstants.POS_SALES_TYPE_FILTER.equals(String.valueOf(params.get("rePosSysTypeId")))) { // 1352
                                                                                                     // filter
                                                                                                     // &
                                                                                                     // spare
                                                                                                     // part
      Map<String, Object> stkMap = new HashMap<String, Object>();
      List<EgovMap> stkList = null;

      stkMap.put("rePosNo", params.get("rePosNo"));
      stkList = posMapper.selectStkCardRecordList(stkMap);

      if (stkList != null && stkList.size() > 0) {
        for (int idx = 0; idx < stkList.size(); idx++) {
          EgovMap reStkMap = null;
          reStkMap = stkList.get(idx);

          stkSeq = posMapper.getSeqLog0014D();

          reStkMap.put("stkSeq", stkSeq);
          reStkMap.put("posRefNo", posRefNo); // irc.RefNo = posRefNo;

          int stkTempQty = Integer.parseInt(String.valueOf(reStkMap.get("qty")));
          stkTempQty = -1 * stkTempQty;
          reStkMap.put("stkTempQty", stkTempQty); // irc.Qty = -1 * irc.Qty;

          reStkMap.put("stkRem", SalesConstants.POS_REM_SOI_COMMENT_INV_VOID + String.valueOf(params.get("rePosNo")));

          LOGGER
              .info("############### 12 - [" + idx + "] POS STOCK RECORD CARD REVERSAL INSERT START  ################");
          LOGGER.info("############### 12 - [" + idx + "] POS STOCK RECORD CARD REVERSAL INSERT PARAM : "
              + reStkMap.toString());
          posMapper.insertStkCardRecordReversal(reStkMap);
          LOGGER.info("############### 12 - [" + idx + "] POS STOCK RECORD CARD REVERSAL INSERT END  ################");

        }
      }
    }

    // Request
    /*
     * Map<String, Object> bookMap = new HashMap<String, Object>();
     *
     * bookMap.put("psno", posRefNo); bookMap.put("retype", "REQ");
     * bookMap.put("pType", "PS02"); // PS02 - cancel bookMap.put("pPrgNm",
     * "PointOfSales"); bookMap.put("userId",
     * Integer.parseInt(String.valueOf(params.get("userId"))));
     *
     * LOGGER.info(
     * "############### 18. POS Booking Reverse  START  ################");
     * LOGGER.info("#########  call Procedure Params : " + bookMap.toString());
     * posMapper.posBookingCallSP_LOGISTIC_POS(bookMap); reqResult =
     * String.valueOf(bookMap.get("p1")); LOGGER.debug(
     * "############ Procedure Result :  " + reqResult); LOGGER.info(
     * "############### 18. POS Booking Reverse  END  ################");
     *
     * if(!"000".equals(reqResult)){ //Err return null; }
     */

    // GetDetailList
    /*
     * List<EgovMap> revDetList = null; bookMap.put("rcvStusId",
     * SalesConstants.POS_DETAIL_NON_RECEIVE); revDetList =
     * posMapper.getPosItmIdListByPosNo(bookMap); LOGGER.info(
     * "@@@@@@@@@@@@@@@@@@@@@@@@@@ revDetList : " + revDetList); for (int idx =
     * 0; idx < revDetList.size(); idx++) {
     *
     * //GI Call Procedure Map<String, Object> giMap = new HashMap<String,
     * Object>();
     *
     * giMap.put("psno", posRefNo); giMap.put("retype", "COM");
     * giMap.put("pType", "PS01"); giMap.put("posItmId",
     * revDetList.get(idx).get("posItmId")); giMap.put("pPrgNm",
     * "PointOfSales"); giMap.put("userId", params.get("userId"));
     *
     * LOGGER.info("############### 19. POS GI Reverse  START  ################"
     * ); LOGGER.info("#########  call Procedure Params : " + giMap.toString());
     * posMapper.posGICallSP_LOGISTIC_POS(giMap); giResult =
     * String.valueOf(giMap.get("p1")); LOGGER.info(
     * "@@@@@@@@@@@@@@@@@@@@@@@@@@ rtnResult : " + giResult); LOGGER.info(
     * "############### 19. POS GI Reverse  END  ################");
     *
     * if(!"000".equals(giResult)){ //Err return null; } }
     */

    // Success
    EgovMap rtnMap = new EgovMap();
    rtnMap.put("posRefNo", posRefNo);
    // rtnMap.put("posWorNo", rorNo);
    return rtnMap;

  }

  @Override
  public List<EgovMap> getPurchMemList(Map<String, Object> params) throws Exception {

    return posMapper.getPurchMemList(params);
  }

  @Override
  @Transactional
  public Boolean updatePosMStatus(PosGridVO pgvo, int userId) throws Exception {

    boolean isErr = false;

    GridDataSet<PosMasterVO> posMGridDataSetList = pgvo.getPosStatusDataSetList();

    List<PosMasterVO> updateList = posMGridDataSetList.getUpdate();

    // Update PosMaster
    for (PosMasterVO pvo : updateList) {

      // Update Pos Master
      posMapper.updatePosMStatus(pvo);

      // Get Pos Detail List
      List<EgovMap> detInfoList = null;
      Map<String, Object> detMap = new HashMap<String, Object>();
      detMap.put("posId", pvo.getPosId());
      detMap.put("rcvStusId", SalesConstants.POS_DETAIL_NON_RECEIVE);

      detInfoList = posMapper.getDetailInfoList(detMap);
      if (detInfoList != null && detInfoList.size() > 0) {

        // GI Call Procedure
        for (int idx = 0; idx < detInfoList.size(); idx++) {

          Map<String, Object> giMap = new HashMap<String, Object>();

          giMap.put("psno", pvo.getPosNo());
          giMap.put("retype", "COM");
          giMap.put("pType", "PS01");
          giMap.put("posItmId", detInfoList.get(idx).get("posItmId"));
          giMap.put("pPrgNm", "PointOfSales");
          giMap.put("userId", userId);

          LOGGER.info(
              "##################################### Header Save Call Procedure (Status Change) : " + giMap.toString());

          posMapper.posGICallSP_LOGISTIC_POS(giMap);

          String rtnResult = String.valueOf(giMap.get("p1"));

          LOGGER.info("@@@@@@@@@@@@@@@@@@@@@@@@@@ rtnResult : " + rtnResult);

          if (!"000".equals(rtnResult)) {
            isErr = true;
            break;
          }

        }

        if (isErr == true) {
          break;
        }

        // Complete to Update Pos Detail
        if (pvo.getStusId() == SalesConstants.POS_SALES_STATUS_COMPLETE) { // to
                                                                           // 4
          pvo.setChangeStatus(SalesConstants.POS_DETAIL_RECEIVE); // to Detail
                                                                  // Status 85
          posMapper.updatePosDStatus(pvo);
        }

      } // Detail Condition
    } // Main Loop

    return isErr;
  }

  @Override
  @Transactional
  public Boolean updatePosDStatus(PosGridVO pgvo, int userId) throws Exception {

    boolean isErr = false;

    GridDataSet<PosDetailVO> posDGridDataSetList = pgvo.getPosDetailStatusDataSetList();

    List<PosDetailVO> updateList = posDGridDataSetList.getUpdate();

    // Update Pos Detail by PosItemID

    for (PosDetailVO pdvo : updateList) {

      posMapper.updatePosDStatusByPosItmId(pdvo);

      // GI Call Procedure
      Map<String, Object> giMap = new HashMap<String, Object>();
      EgovMap posNoMap = new EgovMap();
      posNoMap = posMapper.getPosNobyPosId(pdvo);

      giMap.put("psno", posNoMap.get("posNo"));
      giMap.put("retype", "COM");
      giMap.put("pType", "PS01");
      giMap.put("posItmId", pdvo.getPosItmId());
      giMap.put("pPrgNm", "PointOfSales");
      giMap.put("userId", userId);

      LOGGER.info(
          "##################################### Detail Save Call Procedure (Status Change) : " + giMap.toString());

      posMapper.posGICallSP_LOGISTIC_POS(giMap);

      String rtnResult = String.valueOf(giMap.get("p1"));

      LOGGER.info("@@@@@@@@@@@@@@@@@@@@@@@@@@ rtnResult : " + rtnResult);

      if (!"000".equals(rtnResult)) {
        isErr = true;
        break;
      }

    }

    if (isErr == true) {
      return isErr;
    }

    // Check Detail Status
    if (updateList != null && updateList.size() > 0) {

      int posId = updateList.get(0).getPosId(); // posId

      Map<String, Object> getDetMap = new HashMap<String, Object>();
      getDetMap.put("rePosId", posId);

      List<EgovMap> detailList = null;
      detailList = posMapper.getPosDetailList(getDetMap);

      int cnt = 0;

      for (int idx = 0; idx < detailList.size(); idx++) {
        EgovMap tempMap = detailList.get(idx);
        LOGGER.info("#########################  tempMap.get(rcvStusId)  : ===  " + tempMap.get("rcvStusId"));
        LOGGER
            .info("#########################  cccccccccccccccccccc   : ===  " + SalesConstants.POS_DETAIL_NON_RECEIVE);
        if (Integer.parseInt(String.valueOf(tempMap.get("rcvStusId"))) == (SalesConstants.POS_DETAIL_NON_RECEIVE)) { // 96
          LOGGER.info("##################  NonReceive HAS!!!!@##########################");
          cnt++;
        }
      }

      LOGGER.info("######################### cnt : " + cnt);
      // Update Pos M Status to Complete
      if (cnt == 0) {

        PosMasterVO pvo = new PosMasterVO();
        pvo.setPosId(posId);
        pvo.setStusId(SalesConstants.POS_SALES_STATUS_COMPLETE);

        posMapper.updatePosMStatus(pvo);
      }
    }

    return isErr;
  }

  @Override
  public Boolean updatePosMemStatus(PosGridVO pgvo, int userId) throws Exception {

    boolean isErr = false;

    GridDataSet<PosMemberVO> posMemGridDataSetList = pgvo.getPosMemberStatusDataSetList();

    List<PosMemberVO> updateList = posMemGridDataSetList.getUpdate();

    // Update Pos Detail by PosItemID
    for (PosMemberVO pdvo : updateList) {

      posMapper.updatePosMemStatus(pdvo); // posId memId

      List<EgovMap> memDetList = null;
      memDetList = posMapper.getPosItmIdListByPosIdAndMemId(pdvo);

      for (int idx = 0; idx < memDetList.size(); idx++) {

        // GI Call Procedure
        Map<String, Object> giMap = new HashMap<String, Object>();
        EgovMap posNoMap = new EgovMap();
        posNoMap = posMapper.getPosNobyPosIdForMember(pdvo);

        giMap.put("psno", posNoMap.get("posNo"));
        giMap.put("retype", "COM");
        giMap.put("pType", "PS01");
        giMap.put("posItmId", memDetList.get(idx).get("posItmId"));
        giMap.put("pPrgNm", "PointOfSales");
        giMap.put("userId", userId);

        LOGGER.info(
            "##################################### Member Save Call Procedure (Status Change) : " + giMap.toString());

        posMapper.posGICallSP_LOGISTIC_POS(giMap);

        String rtnResult = String.valueOf(giMap.get("p1"));

        LOGGER.info("@@@@@@@@@@@@@@@@@@@@@@@@@@ rtnResult : " + rtnResult);

        if (!"000".equals(rtnResult)) {
          isErr = false;
          break;
        }

      } // 2th loop

      if (isErr == true) {
        break;
      }
    } // 1st loop

    if (isErr == true) {
      return isErr;
    }

    // Check Detail Status
    if (updateList != null && updateList.size() > 0) {

      int posId = updateList.get(0).getPosId(); // posId

      Map<String, Object> getDetMap = new HashMap<String, Object>();
      getDetMap.put("rePosId", posId);

      List<EgovMap> detailList = null;
      detailList = posMapper.getPosDetailList(getDetMap);

      int cnt = 0;

      for (int idx = 0; idx < detailList.size(); idx++) {
        EgovMap tempMap = detailList.get(idx);
        LOGGER.info("#########################  tempMap.get(rcvStusId)  : ===  " + tempMap.get("rcvStusId"));
        LOGGER
            .info("#########################  cccccccccccccccccccc   : ===  " + SalesConstants.POS_DETAIL_NON_RECEIVE);
        if (Integer.parseInt(String.valueOf(tempMap.get("rcvStusId"))) == (SalesConstants.POS_DETAIL_NON_RECEIVE)) { // 96
          LOGGER.info("##################  NonReceive HAS!!!!@##########################");
          cnt++;
        }
      }

      LOGGER.info("######################### cnt : " + cnt);
      // Update Pos M Status to Complete
      if (cnt == 0) {

        PosMasterVO pvo = new PosMasterVO();
        pvo.setPosId(posId);
        pvo.setStusId(SalesConstants.POS_SALES_STATUS_COMPLETE);

        posMapper.updatePosMStatus(pvo);
      }
    }

    return isErr;

  }

  @Override
  public List<EgovMap> getpayBranchList(Map<String, Object> params) throws Exception {

    return posMapper.getpayBranchList(params);
  }

  @Override
  public List<EgovMap> getDebtorAccList(Map<String, Object> params) throws Exception {

    params.put("accCode", SalesConstants.POS_PAY_DEBTOR_ACC_CODE);

    return posMapper.getDebtorAccList(params);
  }

  @Override
  public List<EgovMap> getBankAccountList(Map<String, Object> parmas) throws Exception {

    return posMapper.getBankAccountList(parmas);
  }

  @Override
  public EgovMap selectAccountIdByBranchId(Map<String, Object> params) throws Exception {

    return posMapper.selectAccountIdByBranchId(params);
  }

  @Override
  public boolean isPaymentKnowOffByPOSNo(Map<String, Object> params) throws Exception {

    List<EgovMap> countPay = posMapper.isPaymentKnowOffByPOSNo(params);

    boolean isRtn = false;

    if (countPay != null) {
      if (countPay.size() >= 3) {
        isRtn = true;
      }
    }

    return isRtn;
  }

  @Override
  public EgovMap posReversalPayDetail(Map<String, Object> params) throws Exception {

    return posMapper.posReversalPayDetail(params);
  }

  @Override
  public List<EgovMap> getPayDetailList(Map<String, Object> params) throws Exception {

    return posMapper.getPayDetailList(params);
  }

  @Override
  public void insertTransactionLog(Map<String, Object> params) throws Exception {

    posMapper.insertTransactionLog(params);
  }

  @Override
  public EgovMap chkMemIdByMemCode(Map<String, Object> params) throws Exception {

    return posMapper.chkMemIdByMemCode(params);
  }

  @Override
  public EgovMap chkUserIdByUserName(Map<String, Object> params) throws Exception {

    return posMapper.chkUserIdByUserName(params);
  }

  @Override
  public List<EgovMap> getPosBillingDetailList(Map<String, Object> params) throws Exception {

    return posMapper.getPosBillingDetailList(params);
  }

  @Override
  public List<EgovMap> selectPosFlexiJsonList(Map<String, Object> params) throws Exception {

    return posMapper.selectPosFlexiJsonList(params);
  }

  @Override
  public Map<String, Object> insertPosFlexi(Map<String, Object> params) throws Exception {

    String docNoPsn = ""; // returnValue
    String docNoInvoice = "";

    // Form
    Map<String, Object> posMap = (Map<String, Object>) params.get("form");
    // Grid1
    List<Object> basketGrid = (List<Object>) params.get("prch");
    // Grid2
    List<Object> serialGrid = (List<Object>) params.get("serial");
    // Grid3
    List<Object> memGird = (List<Object>) params.get("mem");
    // Grid4
    List<Object> payGrid = (List<Object>) params.get("pay");
    // pay Form
    Map<String, Object> payFormMap = (Map<String, Object>) params.get("payform");

    params.put("docNoId", SalesConstants.POS_DOC_NO_PSN_NO);
    docNoPsn = posMapper.getDocNo(params); //////////////////////// PSN (144)
    params.put("docNoId", SalesConstants.POS_DOC_NO_INVOICE_NO);
    docNoInvoice = posMapper.getDocNo(params); //////////////////// INVOICE
                                               //////////////////// (143)

    EgovMap nameMAp = null;
    nameMAp = posMapper.getUserFullName(posMap);
    BigDecimal tempTotalAmt = new BigDecimal("0");
    BigDecimal tempTotalTax = new BigDecimal("0");
    ;
    BigDecimal tempTotalCharge = new BigDecimal("0");
    ;
    BigDecimal calHundred = new BigDecimal("100");
    BigDecimal calGst = new BigDecimal(SalesConstants.POS_INV_ITM_GST_RATE);
    BigDecimal tempCal = calHundred.add(calGst);

    for (int i = 0; i < basketGrid.size(); i++) {
      Map<String, Object> amtMap = null;

      amtMap = (Map<String, Object>) basketGrid.get(i);
      BigDecimal tempQty = new BigDecimal(String.valueOf(amtMap.get("inputQty")));
      BigDecimal tempUnitPrc = new BigDecimal(String.valueOf(amtMap.get("amt")));

      BigDecimal tempCurAmt = tempUnitPrc.multiply(tempQty); // Prc * Qty
      BigDecimal tempCurCharge = tempCurAmt; // Charges
      BigDecimal tempCurTax = tempCurAmt.subtract(tempCurCharge); // Tax

      LOGGER.info("__________________________________________________________________________________________");
      LOGGER.info("_____________NO.[" + i + "] =  prc : " + tempUnitPrc + ",  qty : " + tempQty + " , total Amt : "
          + tempCurAmt + " , total Tax : " + tempCurTax + " , total Charges : " + tempCurCharge);
      LOGGER.info("__________________________________________________________________________________________");

      tempTotalAmt = tempTotalAmt.add(tempCurAmt);
      tempTotalTax = tempTotalTax.add(tempCurTax);
      tempTotalCharge = tempTotalCharge.add(tempCurCharge);

    }

    double rtnAmt = tempTotalAmt.doubleValue();
    double rtnTax = tempTotalTax.doubleValue();
    double rtnCharge = tempTotalCharge.doubleValue();

    LOGGER.info("_____________________________________________________________________________________");
    LOGGER.info("_______________________ TOTAL PRICE : " + rtnAmt + " , TOTAL TAX : " + rtnTax + " , TOTAL CHARGES : "
        + rtnCharge);
    LOGGER.info("_____________________________________________________________________________________");

    int posMasterSeq = posMapper.getSeqSal0057D(); // master Sequence
    EgovMap memCodeMap = null;
    memCodeMap = posMapper.selectMemberByMemberIDCode(params);

    posMap.put("drAccId", SalesConstants.POS_DRACC_ID_ITEMBANK); // 540 //122111
    posMap.put("crAccId", SalesConstants.POS_CRACC_ID_ITEMBANK); // 549 //601510
    posMap.put("posMasterSeq", posMasterSeq); // posId = 0 -- 시퀀스
    posMap.put("docNoPsn", docNoPsn); // posNo = 0 --문서채번
    posMap.put("posBillId", SalesConstants.POS_BILL_ID); // pos Bill Id // 0
    posMap.put("posTotalAmt", rtnAmt);
    posMap.put("posCharge", rtnCharge);
    posMap.put("posTaxes", rtnTax);
    posMap.put("posDiscount", 0);

    if (posMap.get("hidLocId") == null) {
      posMap.put("hidLocId", "0");
    }

    posMap.put("posMtchId", 0);
    posMap.put("posCustomerId", SalesConstants.POS_CUST_ID); // 107205
    posMap.put("userId", params.get("userId"));
    posMap.put("userDeptId", 0);

    if (params.get("userDeptId") == null) {
      params.put("userDeptCode", " ");
    }

    posMap.put("posCustName", nameMAp.get("name"));
    posMap.put("userDeptCode", params.get("userDeptId"));
    posMap.put("posStusId", 107); // Pending for Approve
    posMap.put("userId", params.get("userId"));

    if (posMap.get("posReason") == null || String.valueOf(posMap.get("posReason")).equals("")) {
      posMap.put("posReason", "0");
    }

    // Pos Master Insert
    posMapper.insertPosMaster(posMap);

    if ((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf(posMap.get("insPosModuleType"))) // 2390
    ) {
      for (int idx = 0; idx < basketGrid.size(); idx++) { // basket Grid
        Map<String, Object> itemMap = (Map<String, Object>) basketGrid.get(idx);

        int posDetailSeq = posMapper.getSeqSal0058D(); // detail Sequence
        itemMap.put("posDetailSeq", posDetailSeq);
        itemMap.put("posMasterSeq", posMasterSeq);
        itemMap.put("posItemTaxCodeId", SalesConstants.POS_ITM_TAX_CODE_ID); // 32
        itemMap.put("posMemId", posMap.get("salesmanPopId")); // MEM_ID
        itemMap.put("posRcvStusId", 1); // Active
        itemMap.put("userId", params.get("userId"));
        posMapper.insertPosDetail(itemMap);
      } // Detail Insert End

      System.out.println("----------------------------");
      System.out.println(posMap);
      System.out.println("----------------------------");

      if(posMap.get("hidLrpId") != null){
        posMapper.updateLoyaltyRewardPoint(posMap);
      }

      // Serial Insert
      if (serialGrid != null) {
        for (int i = 0; i < serialGrid.size(); i++) {
          Map<String, Object> serialMap = (Map<String, Object>) serialGrid.get(i);
          int serialSeq = posMapper.getSeqSal0147M();
          serialMap.put("serialSeq", serialSeq);
          serialMap.put("posMasterSeq", posMasterSeq);
          serialMap.put("userId", params.get("userId"));
          posMapper.insertSerialNo(serialMap);

        }
      }

    }

    /*
     * Map<String, Object> accBillingMap = new HashMap<String, Object>(); int
     * posBillSeq = posMapper.getSeqPay0007D(); accBillingMap.put("posBillSeq",
     * posBillSeq); // accbilling.BillID = 0; accBillingMap.put("posBillTypeId",
     * SalesConstants.POS_BILL_TYPE_ID); //accbilling.BillTypeID = 569;
     * accBillingMap.put("posBillSoId", 0); // accbilling.BillSOID = 0;
     * accBillingMap.put("posBillMemId", posMap.get("salesmanPopId")); //
     * accbilling.BillMemID = 0; accBillingMap.put("posBillAsId", 0);
     * //accbilling.BillASID = 0; accBillingMap.put("posBillPayTypeId", 0);
     * //accbilling.BillPayTypeID = 0; accBillingMap.put("docNoPsn", docNoPsn);
     * // accbilling.BillNo = ""; //update later //POS RefNo.
     * accBillingMap.put("posMemberShipNo", ""); //accbilling.BillMemberShipNo =
     * ""; accBillingMap.put("posBillAmt", rtnAmt); // accbilling.BillAmt =
     * Convert.ToDouble(totalcharges); accBillingMap.put("posBillRem",
     * posMap.get("posRemark")); //accbilling.BillRemark =
     * this.txtRemark.Text.Trim(); accBillingMap.put("posBillIsPaid", 1);
     * //accbilling.BillIsPaid = true; accBillingMap.put("posBillIsComm", 0); //
     * accbilling.BillIsComm = false; accBillingMap.put("userId",
     * params.get("userId")); accBillingMap.put("posSyncChk", 1);
     * //accbilling.SyncCheck = true; accBillingMap.put("posCourseId", 0);
     * //accbilling.CourseID = 0; accBillingMap.put("posStatusId", 1);//
     * accbilling.StatusID = 1;
     *
     * posMapper.insertPosBilling(accBillingMap);
     *
     * Map<String, Object> posUpMap = new HashMap<String, Object>();
     * posUpMap.put("posBillSeq", posBillSeq); posUpMap.put("posMasterSeq",
     * posMasterSeq); posMapper.updatePosMasterPosBillId(posUpMap);
     *
     * Map<String, Object> accOrdBillingMap = new HashMap<String, Object>(); int
     * accOrderBillSeq = posMapper.getSeqPay0016D();
     *
     * accOrdBillingMap.put("posOrderBillSeq", accOrderBillSeq);
     * //accorderbill.AccBillID = 0; accOrdBillingMap.put("posOrdBillTaskId",
     * 0); // accorderbill.AccBillTaskID = 0;
     * accOrdBillingMap.put("posOrdBillRefNo", "1000");
     * //accorderbill.AccBillRefNo = "1000"; //update later //at db
     * accOrdBillingMap.put("posOrdBillOrdId", 0); //accorderbill.AccBillOrderID
     * = 0; accOrdBillingMap.put("posOrdBillOrdNo", "");
     * //accorderbill.AccBillOrderNo = "";
     * accOrdBillingMap.put("posOrdBillTypeId",
     * SalesConstants.POS_ORD_BILL_TYPE_ID); //accorderbill.AccBillTypeID =
     * 1159; //System Generate Bill accOrdBillingMap.put("posOrdBillModeId",
     * SalesConstants.POS_ORD_BILL_MODE_ID); //accorderbill.AccBillModeID =
     * 1351; //SOI Bill (POS New Version)
     * accOrdBillingMap.put("posOrdBillScheduleId", 0); //
     * accorderbill.AccBillScheduleID = 0;
     * accOrdBillingMap.put("posOrdBillSchedulePeriod", 0);
     * //accorderbill.AccBillSchedulePeriod = 0;
     * accOrdBillingMap.put("posOrdBillAdjustmentId", 0);
     * //accorderbill.AccBillAdjustmentID = 0;
     * accOrdBillingMap.put("posOrdBillScheduleAmt", rtnAmt);
     * //accorderbill.AccBillScheduleAmount = decimal.Parse(totalcharges);
     * accOrdBillingMap.put("posOrdBillAdjustmentAmt", 0);
     * //accorderbill.AccBillAdjustmentAmount = 0;
     * accOrdBillingMap.put("posOrdBillTaxesAmt", rtnTax);
     * //accorderbill.AccBillTaxesAmount =
     * Convert.ToDecimal(string.Format("{0:0.00}", decimal.Parse(totalcharges) -
     * (System.Convert.ToDecimal(totalcharges) * 100 / 106)));
     * accOrdBillingMap.put("posOrdBillNetAmount", rtnAmt); //
     * accorderbill.AccBillNetAmount = decimal.Parse(totalcharges);
     * accOrdBillingMap.put("posOrdBillStatus", 1); //accorderbill.AccBillStatus
     * = 1; accOrdBillingMap.put("posOrdBillRem", docNoInvoice);
     * //accorderbill.AccBillRemark = ""; //Invoice No.
     * accOrdBillingMap.put("userId", params.get("userId"));
     * accOrdBillingMap.put("posOrdBillGroupId", 0);
     * //accorderbill.AccBillGroupID = 0;
     * accOrdBillingMap.put("posOrdBillTaxCodeId",
     * SalesConstants.POS_ORD_BILL_TAX_CODE_ID); //accorderbill.AccBillTaxCodeID
     * = 32; accOrdBillingMap.put("posOrdBillTaxRate", 0);
     * //accorderbill.AccBillTaxRate = 6;
     * accOrdBillingMap.put("posOrdBillAcctCnvr", 0); //TODO ASIS 소스 없음
     * accOrdBillingMap.put("posOrdBillCntrctId", 0); //TODO ASIS 소스 없음
     *
     * posMapper.insertPosOrderBilling(accOrdBillingMap);
     *
     * Map<String, Object> accTaxInvoiceMiscellaneouMap = new HashMap<String,
     * Object>(); int accTaxInvMiscSeq = posMapper.getSeqPay0031D();
     *
     * accTaxInvoiceMiscellaneouMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq);
     * //InvMiscMaster.TaxInvoiceID = 0;
     * accTaxInvoiceMiscellaneouMap.put("posTaxInvRefNo", docNoInvoice);
     * //InvMiscMaster.TaxInvoiceRefNo = ""; //update later
     * accTaxInvoiceMiscellaneouMap.put("posTaxInvSvcNo", docNoPsn);
     * //InvMiscMaster.TaxInvoiceServiceNo = ""; //SOI No.
     * accTaxInvoiceMiscellaneouMap.put("posTaxInvType",
     * SalesConstants.POS_TAX_INVOICE_TYPE); // InvMiscMaster.TaxInvoiceType =
     * 142; //pos new version
     * accTaxInvoiceMiscellaneouMap.put("posTaxInvCustName",
     * nameMAp.get("name")); // InvMiscMaster.TaxInvoiceCustName =
     * this.txtCustName.Text.Trim();
     * accTaxInvoiceMiscellaneouMap.put("posTaxInvCntcPerson",
     * nameMAp.get("name")); // InvMiscMaster.TaxInvoiceContactPerson =
     * this.txtCustName.Text.Trim();
     * accTaxInvoiceMiscellaneouMap.put("posTaxInvTaskId", 0);
     * //InvMiscMaster.TaxInvoiceTaskID = 0;
     * accTaxInvoiceMiscellaneouMap.put("posTaxInvUserName",
     * params.get("userName")); // InvMiscMaster.TaxInvoiceRemark = li.LoginID;
     * accTaxInvoiceMiscellaneouMap.put("posTaxInvCharges", rtnCharge); //
     * InvMiscMaster.TaxInvoiceCharges =
     * Convert.ToDecimal(string.Format("{0:0.00}", (decimal.Parse(totalcharges)
     * * 100 / 106))); accTaxInvoiceMiscellaneouMap.put("posTaxInvTaxes",
     * rtnTax); //InvMiscMaster.TaxInvoiceTaxes =
     * Convert.ToDecimal(string.Format("{0:0.00}", decimal.Parse(totalcharges) -
     * (decimal.Parse(totalcharges) * 100 / 106)));
     * accTaxInvoiceMiscellaneouMap.put("posTaxInvTotalCharges", rtnAmt);
     * //InvMiscMaster.TaxInvoiceAmountDue = decimal.Parse(totalcharges);
     * accTaxInvoiceMiscellaneouMap.put("userId", params.get("userId"));
     * posMapper.insertPosTaxInvcMisc(accTaxInvoiceMiscellaneouMap);
     */

    /*
     * int invItemTypeID = 5552;
     *
     * for (int idx = 0; idx < basketGrid.size(); idx++) { Map<String, Object>
     * invDetailMap = new HashMap<String, Object>(); invDetailMap = (Map<String,
     * Object>)basketGrid.get(idx); int invDetailSeq =
     * posMapper.getSeqPay0032D();
     *
     * invDetailMap.put("invDetailSeq", invDetailSeq); //InvMiscD.InvocieItemID
     * = 0; invDetailMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq);
     * //InvMiscD.TaxInvoiceID = 0; //update later
     * invDetailMap.put("invItemTypeID", invItemTypeID);
     * //InvMiscD.InvoiceItemType = invItemTypeID;
     * invDetailMap.put("posTaxInvSubOrdNo", ""); //InvMiscD.InvoiceItemOrderNo
     * = ""; invDetailMap.put("posTaxInvSubItmPoNo", "");
     * //InvMiscD.InvoiceItemPONo = ""; invDetailMap.put("posTaxInvSubDescSub",
     * ""); //InvMiscD.InvoiceItemDescription2 = "";
     * invDetailMap.put("posTaxInvSubSerialNo", "");
     * //InvMiscD.InvoiceItemSerialNo = "";
     * invDetailMap.put("posTaxInvSubGSTRate", 0); //InvMiscD.InvoiceItemGSTRate
     * = 6; posMapper.insertPosTaxInvcMiscSub(invDetailMap); }
     */
    /*
     * if((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf
     * (posMap.get("insPosModuleType")))){ //2390 -- POS SALES
     *
     * String trxNo = ""; String worNo = ""; int trxSeq = 0; int groupSeq = 0;
     *
     * Map<String, Object> trxMap = new HashMap<String, Object>();
     *
     * //DOC(23) //TODO 문서 채번 후 미사용 params.put("docNoId",
     * SalesConstants.POS_DOC_NO_TRX_NO); //(23) trxNo =
     * posMapper.getDocNo(params);
     *
     * //DOC(3) params.put("docNoId", SalesConstants.POS_DOC_NO_WOR_NO); //(3)
     * worNo = posMapper.getDocNo(params);
     *
     * //Seq trxSeq = posMapper.getSeqPay0069D(); groupSeq =
     * posMapper.getSeqPay0240T();
     *
     * trxMap.put("trxSeq", trxSeq); trxMap.put("trxType",
     * SalesConstants.POS_TRX_TYPE_ID); trxMap.put("trxAmt",
     * payFormMap.get("hidTotPayAmt")); trxMap.put("trxMatchNo", "");
     *
     * posMapper.insertPayTrx(trxMap);
     *
     * Map<String, Object> paymMap = new HashMap<String, Object>();
     *
     * int payMseq = posMapper.getSeqPay0064D();
     *
     * paymMap.put("payMseq", payMseq); paymMap.put("orNo", worNo); //doc
     * paymMap.put("salesOrdId", SalesConstants.POS_TEMP_SALES_ORDER_ID); //0
     * paymMap.put("billId", posBillSeq); //accbilling.billId ( payM.BillID =
     * accbilling.BillID;)
     *
     * String trNo = ""; if(payFormMap.get("payTrRefNo") != null){ trNo =
     * String.valueOf(payFormMap.get("payTrRefNo")); trNo =
     * trNo.trim().toUpperCase(); }else{ trNo = " "; } paymMap.put("trNo",
     * trNo); //payM.TRNo = (!string.IsNullOrEmpty(this.txtTrRefNo.Text.Trim()))
     * ? this.txtTrRefNo.Text.ToUpper() : ""; paymMap.put("typeId",
     * SalesConstants.POS_PAY_MASTER_TYPE_ID); // 577 paymMap.put("bankChgAmt",
     * SalesConstants.POS_BANK_CHARGE_AMOUNT); paymMap.put("bankChgAccId",
     * SalesConstants.POS_BANK_CHARGE_ACCOUNT_ID); paymMap.put("collMemId",
     * SalesConstants.POS_COLL_MEMBER_ID);
     *
     * //brnchId paymMap.put("brnchId", payFormMap.get("payBrnchCode"));
     *
     * //Debtor Acc. paymMap.put("bankAccId", payFormMap.get("payDebtorAcc"));
     *
     * paymMap.put("allowComm", SalesConstants.POS_PAY_ALLOW_COMM);
     * paymMap.put("stusCodeId", SalesConstants.POS_PAY_STATUS_ID);
     *
     * //userId paymMap.put("updUserId", params.get("userId"));
     *
     * paymMap.put("syncCheck", SalesConstants.POS_PAY_SYNC_CHECK);
     * paymMap.put("thirdPartyCustId", SalesConstants.POS_THIRD_PARTY_CUST_ID);
     *
     * //total Amt paymMap.put("totAmt", payFormMap.get("hidTotPayAmt"));
     * paymMap.put("matchId", SalesConstants.POS_MATCH_ID);
     *
     * //userId paymMap.put("crtUserId", params.get("userId"));
     * paymMap.put("isAllowRevMulti", SalesConstants.POS_IS_ALLOW_REV_MULTY);
     * paymMap.put("isGlPostClm", SalesConstants.POS_IS_GL_POST_CLAIM);
     * paymMap.put("glPostClmDt", SalesConstants.DEFAULT_DATE);
     * paymMap.put("trxSeq", trxSeq); //trxId paymMap.put("advMonth",
     * SalesConstants.POS_ADV_MONTH); paymMap.put("orderBillId",
     * accOrderBillSeq); // payM.AccBillID = accorderbill.AccBillID;
     *
     * //TR Issued Date if(payFormMap.get("payTrIssueDate") != null){
     * paymMap.put("trIssuDt", payFormMap.get("payTrIssueDate")); }else{
     * paymMap.put("trIssuDt", SalesConstants.DEFAULT_DATE); }
     *
     * paymMap.put("payInvIsGen", SalesConstants.POS_TAX_INVOICE_GENERATED);
     * paymMap.put("taxInvcRefNo", docNoInvoice); //payM.TaxInvoiceRefNo =
     * InvoiceNum; paymMap.put("svcCntrctId",
     * SalesConstants.POS_SERVICE_CONTRACT_ID); paymMap.put("batchPayId",
     * SalesConstants.POS_BATCH_PAYMEMNT_ID);
     *
     * posMapper.insertPayMaster(paymMap);
     */

    /*
     * for (int idx = 0; idx < payGrid.size(); idx++) { Map<String, Object>
     * paydMap = new HashMap<String, Object>();
     *
     * paydMap = (Map<String, Object>)payGrid.get(idx);
     *
     * int posDSeq = 0; posDSeq = posMapper.getSeqPay0065D();
     * paydMap.put("payItemId", posDSeq); paydMap.put("payId", payMseq);
     *
     * if(paydMap.get("transactionRefNo") != null && "" !=
     * paydMap.get("transactionRefNo")){ String payRefNo = ""; payRefNo =
     * String.valueOf(paydMap.get("transactionRefNo")); payRefNo =
     * payRefNo.toUpperCase(); paydMap.put("transactionRefNo", payRefNo); }
     */
    /*
     * if(paydMap.get("payCrcMode") != null && "" != paydMap.get("payCrcMode")){
     * String payCrcMode = ""; payCrcMode =
     * String.valueOf(paydMap.get("payCrcMode"));
     *
     * if(("ONLINE").equals(payCrcMode)){ paydMap.put("payCrcMode", "1"); }else{
     * paydMap.put("payCrcMode", "0"); } }else{ paydMap.put("payCrcMode", "0");
     * }
     *
     * if(paydMap.get("payRefDate") == null || paydMap.get("payRefDate") == ""
     * ){ paydMap.put("payRefDate", SalesConstants.DEFAULT_DATE); }
     *
     * paydMap.put("payItmStusId", SalesConstants.POS_PAY_STATUS_ID);
     *
     * paydMap.put("payItmIsLok", SalesConstants.POS_PAY_ITEM_IS_LOCK);
     * paydMap.put("payItmIsThirdParty",
     * SalesConstants.POS_PAY_ITEM_IS_THIRD_PARTY); paydMap.put("isFundTrnsfr",
     * SalesConstants.POS_IS_FUND_TRANS_FR); paydMap.put("skipRecon",
     * SalesConstants.POS_SKIP_RECON);
     *
     * posMapper.insertPayDetail(paydMap);
     *
     *
     * }//Loop End //PAYMENT GRID 가져옴 }
     */
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("reqDocNo", docNoPsn);

    LOGGER.info("##################### POS Request Success!!! ######################################");

    rtnMap.put("logError", "000");

    return rtnMap;
  }

  @Override
  public List<EgovMap> selectPosFlexiItmList(Map<String, Object> params) throws Exception {

    return posMapper.selectPosFlexiItmList(params);
  }

  @Override
  public List<EgovMap> chkFlexiStockList(Map<String, Object> params) throws Exception {

    List<EgovMap> retunList = null;

    retunList = posMapper.chkFlexiStockList(params);

    return retunList;
  }

  @Override
  public EgovMap posFlexiDetail(Map<String, Object> params) throws Exception {

    return posMapper.posFlexiDetail(params);
  }

  @Override
  @Transactional
  public Map<String, Object> updatePosFlexiStatus(Map<String, Object> params, SessionVO sessionVO)
      throws ParseException {

    LOGGER.debug("params : " + params);
    Map<String, Object> resultValue = new HashMap<String, Object>();
    params.put("approvalUserId", sessionVO.getUserId());
    posMapper.updatePosFlexiStatus(params);
    return resultValue;
  }

  @Override
  public List<EgovMap> selectWhSOBrnchList(Map<String, Object> params) throws Exception {
    return posMapper.selectWhSOBrnchList(params);
  }

  @Override
  public List<EgovMap> selectPOSFlexiItem(Map<String, Object> params) {
    return posMapper.selectPOSFlexiItem(params);
  }

  @Override
  public int updatePOSFlexiItemActive(Map<String, Object> params, SessionVO sessionVO) {
    // TODO Auto-generated method stub
    int cnt = 0;
    params.put("updUserId", sessionVO.getUserId());
    posMapper.updatePOSFlexiItemActive(params);
    return cnt;
  }

  @Override
  public int updatePOSFlexiItemInactive(Map<String, Object> params, SessionVO sessionVO) {
    // TODO Auto-generated method stub
    int cnt = 0;
    params.put("updUserId", sessionVO.getUserId());
    posMapper.updatePOSFlexiItemInactive(params);
    return cnt;
  }

  @Override
  public Map<String, Object> insertPosSerial(Map<String, Object> params) throws Exception {

    String docNoPsn = ""; // returnValue
    String docNoInvoice = "";
    LOGGER.info("############### get Params  ################");
    /* ############### get Params ################ */
    // Form
    Map<String, Object> posMap = (Map<String, Object>) params.get("form");
    // Grid1
    List<Object> basketGrid = (List<Object>) params.get("prch");
    // Grid2
    List<Object> serialGrid = (List<Object>) params.get("serial");
    // Grid3
    List<Object> memGird = (List<Object>) params.get("mem");
    // Grid4
    List<Object> payGrid = (List<Object>) params.get("pay");
    // pay Form
    Map<String, Object> payFormMap = (Map<String, Object>) params.get("payform");

    LOGGER.info("############### get DOC Number & Sequence & full Name & Amounts  ################");
    /*
     * ############## get DOC Number & Sequence & full Name & Amounts
     * ###########
     */
    params.put("docNoId", SalesConstants.POS_DOC_NO_PSN_NO);
    docNoPsn = posMapper.getDocNo(params); //////////////////////// PSN (144)
    params.put("docNoId", SalesConstants.POS_DOC_NO_INVOICE_NO);
    docNoInvoice = posMapper.getDocNo(params); //////////////////// INVOICE
                                               //////////////////// (143)

    LOGGER.info("################################## docNoPsn : " + docNoPsn);
    LOGGER.info("################################## docNoInvoice : " + docNoInvoice);

    EgovMap nameMAp = null;
    nameMAp = posMapper.getUserFullName(posMap);

    BigDecimal tempTotalAmt = new BigDecimal("0");
    BigDecimal tempTotalTax = new BigDecimal("0");
    ;
    BigDecimal tempTotalCharge = new BigDecimal("0");
    ;
    BigDecimal tempTotalDiscount = new BigDecimal("0");

    BigDecimal calHundred = new BigDecimal("100");
    BigDecimal calGst = new BigDecimal(SalesConstants.POS_INV_ITM_GST_RATE);
    BigDecimal tempCal = calHundred.add(calGst);

    // BigDecimal deducSize = new BigDecimal(basketGrid.size()); // Deduction
    // Size
    LOGGER.info("########################## tempCal : " + tempCal);
    for (int i = 0; i < basketGrid.size(); i++) {
      Map<String, Object> amtMap = null;

      amtMap = (Map<String, Object>) basketGrid.get(i);
      BigDecimal tempQty = new BigDecimal(String.valueOf(amtMap.get("inputQty")));
      BigDecimal tempUnitPrc = new BigDecimal(String.valueOf(amtMap.get("amt")));

      BigDecimal tempCurAmt = tempUnitPrc.multiply(tempQty); // Prc * Qty
      BigDecimal tempCurCharge = tempCurAmt; // Charges
      BigDecimal tempCurTax = tempCurAmt.subtract(tempCurCharge); // Tax
      BigDecimal tempDiscount = new BigDecimal(String.valueOf(amtMap.get("totalDiscount")));

      LOGGER.info("__________________________________________________________________________________________");
      LOGGER.info("_____________NO.[" + i + "] =  prc : " + tempUnitPrc + ",  qty : " + tempQty + " , total Amt : "
          + tempCurAmt + " , total Tax : " + tempCurTax + " , total Charges : " + tempCurCharge + " , total Discount : " + tempDiscount);
      LOGGER.info("__________________________________________________________________________________________");

      tempTotalAmt = tempTotalAmt.add(tempCurAmt);
      tempTotalTax = tempTotalTax.add(tempCurTax);
      tempTotalCharge = tempTotalCharge.add(tempCurCharge);
      tempTotalDiscount = tempTotalDiscount.add(tempDiscount);

    }

    double rtnAmt = tempTotalAmt.doubleValue();
    double rtnTax = tempTotalTax.doubleValue();
    double rtnCharge = tempTotalCharge.doubleValue();
    double rtnDiscount = tempTotalDiscount.doubleValue();
    rtnAmt = rtnAmt - rtnDiscount;

    if ((SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION)
        .equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2391

      /*
       * rtnAmt = rtnAmt *memGird.size(); rtnTax = rtnTax*memGird.size();
       * rtnCharge = rtnCharge*memGird.size();
       */

    }

    LOGGER.info("_____________________________________________________________________________________");
    LOGGER.info("_______________________ TOTAL PRICE : " + rtnAmt + " , TOTAL TAX : " + rtnTax + " , TOTAL CHARGES : "
        + rtnCharge + ", TOTAL DISCOUNT : " + rtnDiscount + " ");
    LOGGER.info("_____________________________________________________________________________________");

    LOGGER.info("############### Parameter Setting , Insert and Update  ################");
    /* #### Parameter Setting , Insert and Update ###### */

    // 1.
    // *********************************************************************************************************
    // POS MASTER
    // Seq
    int posMasterSeq = posMapper.getSeqSal0057D(); // master Sequence

    // DRAccId , CRAccId Setting
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)) { // 1352
                                                                                                       // //filter
                                                                                                       // with
                                                                                                       // payment

      posMap.put("drAccId", SalesConstants.POS_DRACC_ID_FILTER); // 540 //122111
      posMap.put("crAccId", SalesConstants.POS_CRACC_ID_FILTER); // 541 //414002
    }
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK)) { // 1353
                                                                                                        // //itembank
                                                                                                        // with
                                                                                                        // payment

      posMap.put("drAccId", SalesConstants.POS_DRACC_ID_ITEMBANK); // 540
                                                                   // //122111
      posMap.put("crAccId", SalesConstants.POS_CRACC_ID_ITEMBANK); // 549
                                                                   // //601510
    }
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)
        || String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK_HQ)) { // 1357
                                                                                                              // or
                                                                                                              // 1358
      // TODO ASIS 기준으로는 하나의 아이템 타입만 구입할 수있었으니 지금은 여러가지 타입의 아이템을 구할수 있으므로 해당 로직
      // 사용 불가함 //임의 수치 부여
      // EgovMap accCodeMap = null;
      // accCodeMap = posMapper.getItemBankAccCodeByItemTypeID(posMap);
      posMap.put("drAccId", SalesConstants.POS_DRACC_ID_OTH);
      posMap.put("crAccId", SalesConstants.POS_CRACC_ID_OTH);

    }

    posMap.put("posMasterSeq", posMasterSeq); // posId = 0 -- 시퀀스
    posMap.put("docNoPsn", docNoPsn); // posNo = 0 --문서채번
    posMap.put("posBillId", SalesConstants.POS_BILL_ID); // pos Bill Id // 0

    EgovMap memCodeMap = null;
    memCodeMap = posMapper.selectMemberByMemberIDCode(params);

    // TODO Other Income 만 사용?? Branch 없음 임시 번호 부여
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)) { // 1357
                                                                                                             // Other
                                                                                                             // Income

      posMap.put("othCheck", SalesConstants.POS_OTH_CHECK_PARAM); // OTH Check
      posMap.put("posCustName", posMap.get("insPosCustName")); // posCustName =
                                                               // other Income만
                                                               // 사용함 .. 그러면
                                                               // 나머지는??
      params.put("memCode", params.get("userName"));
      /*
       * EgovMap memCodeMap = null; memCodeMap =
       * posMapper.selectMemberByMemberIDCode(params);
       */

      // TODO IVYLIM is NULL
      if (memCodeMap != null) {
        posMap.put("salesmanPopId", memCodeMap.get("memId"));
      } else {
        posMap.put("salesmanPopId", "0");
      }

    } else {
      posMap.put("posCustName", nameMAp.get("name")); // posCustName = other
                                                      // Income만 사용함 .. 그러면
                                                      // 나머지는??
    }
    posMap.put("posTotalAmt", rtnAmt);
    posMap.put("posCharge", rtnCharge);
    posMap.put("posTaxes", rtnTax);
    posMap.put("posDiscount", rtnDiscount); // TODO 확인 필요
    // hidLocId 와 branch ID
    if (posMap.get("hidLocId") == null) {
      posMap.put("hidLocId", "0");
    }
    posMap.put("posMtchId", 0);
    posMap.put("posCustomerId", SalesConstants.POS_CUST_ID); // 107205
    posMap.put("userId", params.get("userId"));

    /*
     * if(params.get("userDeptId") == null){ params.put("userDeptId", 0); }
     */
    posMap.put("userDeptId", 0);
    if (params.get("userDeptId") == null) {
      params.put("userDeptCode", " ");
    }
    posMap.put("userDeptCode", params.get("userDeptId"));

    // Status Setting
    if ((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2390
                                                                                                                   // //
                                                                                                                   // POS-TYPE
                                                                                                                   // :
                                                                                                                   // POS
                                                                                                                   // SALES

      if (String.valueOf(posMap.get("payResult")).equals("1")) { ////////////////////////////////////////////////////////////////////////////////////////// 1.
                                                                 ////////////////////////////////////////////////////////////////////////////////////////// WITH
                                                                 ////////////////////////////////////////////////////////////////////////////////////////// PAYMENT
        posMap.put("posStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); // STUS_ID
                                                                              // ==
                                                                              // Non
                                                                              // Receive
      } else { //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 2.
               //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// WITHOUT
               //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// PAYMENT
        posMap.put("posStusId", SalesConstants.POS_SALES_STATUS_ACTIVE); // STUS_ID
                                                                         // ==
                                                                         // Active
      }
    }

    if ((SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION)
        .equals(String.valueOf(posMap.get("insPosModuleType"))) || //// 2391
                                                                   //// //POS
                                                                   //// TYPE :
                                                                   //// DEDUCTION
                                                                   //// COMMISSION
                                                                   //// - NO
                                                                   //// PAYMENT
        (SalesConstants.POS_SALES_MODULE_TYPE_OTH).equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2392
                                                                                                             // //POS
                                                                                                             // TYPE
                                                                                                             // :
                                                                                                             // OTHER
      posMap.put("posStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); // STUS_ID
                                                                            // ==
                                                                            // Non
                                                                            // Receive
    }

    // POS TYPE : OTHER INCOME - NO PAYMENT
    /*
     * if("OHTER INCOME 일때"){ posMap.put("posStusId",
     * SalesConstants.POS_SALES_STATUS_NON_RECEIVE); //STUS_ID == Non Receive }
     */

    posMap.put("userId", params.get("userId"));

    if (posMap.get("posReason") == null || String.valueOf(posMap.get("posReason")).equals("")) {
      posMap.put("posReason", "0");
    }

    // Pos Master Insert
    LOGGER.info("############### 1. POS MASTER INSERT START  ################");
    LOGGER.info("############### 1. POS MASTER INSERT param : " + posMap.toString());
    posMapper.insertPosMaster(posMap);
    LOGGER.info("############### 1. POS MASTER INSERT END  ################");
    // 2.
    // *********************************************************************************************************
    // POS DETAIL

    // Grid to Map Params
    // 1). POST TYPE : POS_SALES
    LOGGER.info("************************************* POSMAP`s Params : " + posMap.toString());
    LOGGER.info(
        "************************************* POSMAP - type  : " + String.valueOf(posMap.get("insPosModuleType")));
    LOGGER.info("************************************* POSMAP - constans(pos_sales)  : "
        + SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES);
    LOGGER.info("************************************* POSMAP - constans(deduction_commission)  : "
        + SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION);

    if ((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf(posMap.get("insPosModuleType"))) // 2390
        || (SalesConstants.POS_SALES_MODULE_TYPE_OTH).equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2392
      for (int idx = 0; idx < basketGrid.size(); idx++) { // basket Grid
        Map<String, Object> itemMap = (Map<String, Object>) basketGrid.get(idx);

        int posDetailSeq = posMapper.getSeqSal0058D(); // detail Sequence
        itemMap.put("posDetailSeq", posDetailSeq);
        itemMap.put("posMasterSeq", posMasterSeq);
        itemMap.put("posItemTaxCodeId", SalesConstants.POS_ITM_TAX_CODE_ID); // 32
        itemMap.put("posMemId", posMap.get("salesmanPopId")); // MEM_ID
        itemMap.put("posRcvStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); // RCV_STUS_ID
                                                                                  // 96
                                                                                  // ==
                                                                                  // nonReceive
        itemMap.put("userId", params.get("userId"));
        LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT START  ################");
        LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT param : " + itemMap.toString());
        posMapper.insertPosDetail(itemMap);
        LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT END  ################");

      } // Detail Insert End

      System.out.println("----------------------------");
      System.out.println(posMap);
      System.out.println("----------------------------");

      if(posMap.get("hidLrpId") != null){
        posMapper.updateLoyaltyRewardPoint(posMap);
      }

      // Serial Insert
      if (serialGrid != null) {
        for (int i = 0; i < serialGrid.size(); i++) {
          Map<String, Object> serialMap = (Map<String, Object>) serialGrid.get(i);
          int serialSeq = posMapper.getSeqSal0147M();

          serialMap.put("serialSeq", serialSeq);
          serialMap.put("posMasterSeq", posMasterSeq);
          serialMap.put("userId", params.get("userId"));
          // TODO ITEM Status ID?
          // serialMap.put("posItmStusId", 1);

          LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT START  ################");
          LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT param : " + serialMap.toString());
          posMapper.insertSerialNo(serialMap);
          LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT END  ################");

        }
      }
    }
    // 2). POST TYPE : DEDUCTION COMMISSION //2391
    if ((SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION)
        .equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2391
      for (int idx = 0; idx < basketGrid.size(); idx++) { // basket Grid

        Map<String, Object> deducItemMap = (Map<String, Object>) basketGrid.get(idx); // item
                                                                                      // Map

        LOGGER
            .info("############### 2 - Member(Item) - [" + idx + "]  POS DETAIL(Member) MAP SETTING  ################");
        // for (int i = 0; i < memGird.size(); i++) {
        // Map<String, Object> memMap = (Map<String, Object>)memGird.get(i);
        // //item List
        Map<String, Object> memMap = new HashMap<String, Object>();
        int posDetailDuducSeq = posMapper.getSeqSal0058D(); // detail Sequence
        memMap.put("posDetailDuducSeq", posDetailDuducSeq);
        memMap.put("posMasterSeq", posMasterSeq);
        memMap.put("posDetailStkId", deducItemMap.get("stkId")); // POS_ITM_STOCK_ID
        memMap.put("posDetailQty", deducItemMap.get("inputQty")); // POS_ITM_QTY
        memMap.put("posDetailUnitPrc", deducItemMap.get("amt")); // Price
        memMap.put("posDetailTotal", deducItemMap.get("totalAmt")); // ToTal
        memMap.put("posDetailCharge", deducItemMap.get("subTotal")); // Charge
        memMap.put("posDetailTaxs", deducItemMap.get("subChng")); // Tax
        memMap.put("posItemTaxCodeId", SalesConstants.POS_ITM_TAX_CODE_ID); // 32
        memMap.put("posRcvStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE); // RCV_STUS_ID
                                                                                 // 96
                                                                                 // ==
                                                                                 // nonReceive
        memMap.put("memId", posMap.get("salesmanPopId"));
        memMap.put("memCode", posMap.get("salesmanPopCd"));
        memMap.put("memType", memCodeMap.get("memType"));
        memMap.put("name", posMap.get("posCustName"));
        memMap.put("fullName", posMap.get("posCustName"));
        memMap.put("nric", memCodeMap.get("nric"));
        memMap.put("stus", memCodeMap.get("stus"));
        memMap.put("userId", params.get("userId"));

        // LOGGER.info("############### 2 - Member(Item ["+idx+"]) - MemLoop ["
        // + i + "] POS DETAIL(Member) INSERT START ################");
        // LOGGER.info("############### 2 - Member(Item ["+idx+"]) - MemLoop ["
        // + i + "] POS DETAIL(Member) INSERT param : " + memMap.toString());
        posMapper.insertDeductionPosDetail(memMap);
        // LOGGER.info("############### 2 - Member(Item ["+idx+"]) - MemLoop ["
        // + i + "] POS DETAIL(Member) INSERT END ################");
        // }
        LOGGER.info(
            "############### 2 - Member(Item) - [" + idx + "]  POS DETAIL(Member) MAP SETTING END  ################");

      }
    }

    // 3.
    // *********************************************************************************************************
    // ACC BILLING
    Map<String, Object> accBillingMap = new HashMap<String, Object>();
    int posBillSeq = posMapper.getSeqPay0007D();
    accBillingMap.put("posBillSeq", posBillSeq); // accbilling.BillID = 0;
    accBillingMap.put("posBillTypeId", SalesConstants.POS_BILL_TYPE_ID); // accbilling.BillTypeID
                                                                         // =
                                                                         // 569;
    accBillingMap.put("posBillSoId", 0); // accbilling.BillSOID = 0;
    accBillingMap.put("posBillMemId", posMap.get("salesmanPopId")); // accbilling.BillMemID
                                                                    // = 0;
    accBillingMap.put("posBillAsId", 0); // accbilling.BillASID = 0;
    accBillingMap.put("posBillPayTypeId", 0); // accbilling.BillPayTypeID = 0;
    accBillingMap.put("docNoPsn", docNoPsn); // accbilling.BillNo = ""; //update
                                             // later //POS RefNo.
    accBillingMap.put("posMemberShipNo", ""); // accbilling.BillMemberShipNo =
                                              // "";
    accBillingMap.put("posBillAmt", rtnAmt); // accbilling.BillAmt =
                                             // Convert.ToDouble(totalcharges);
    accBillingMap.put("posBillRem", posMap.get("posRemark")); // accbilling.BillRemark
                                                              // =
                                                              // this.txtRemark.Text.Trim();
    accBillingMap.put("posBillIsPaid", 1); // accbilling.BillIsPaid = true;
    accBillingMap.put("posBillIsComm", 0); // accbilling.BillIsComm = false;
    accBillingMap.put("userId", params.get("userId"));
    accBillingMap.put("posSyncChk", 1); // accbilling.SyncCheck = true;
    accBillingMap.put("posCourseId", 0); // accbilling.CourseID = 0;
    accBillingMap.put("posStatusId", 1);// accbilling.StatusID = 1;
    LOGGER.info("############### 3. POS ACC BILLING INSERT START  ################");
    LOGGER.info("############### 3. POS ACC BILLING INSERT param : " + accBillingMap.toString());
    posMapper.insertPosBilling(accBillingMap);
    LOGGER.info("############### 3. POS ACC BILLING INSERT END  ################");

    // 4.
    // *********************************************************************************************************
    // POS MASTER UPDATE BILL_ID
    Map<String, Object> posUpMap = new HashMap<String, Object>();
    posUpMap.put("posBillSeq", posBillSeq);
    posUpMap.put("posMasterSeq", posMasterSeq);
    LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE START  ################");
    LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE param : " + posUpMap.toString());
    posMapper.updatePosMasterPosBillId(posUpMap);
    LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE END  ################");

    // 5.
    // *********************************************************************************************************
    // ACC ORDER BILL

    // 3. ACCORDERBILLING
    Map<String, Object> accOrdBillingMap = new HashMap<String, Object>();
    int accOrderBillSeq = posMapper.getSeqPay0016D();

    accOrdBillingMap.put("posOrderBillSeq", accOrderBillSeq); // accorderbill.AccBillID
                                                              // = 0;
    accOrdBillingMap.put("posOrdBillTaskId", 0); // accorderbill.AccBillTaskID =
                                                 // 0;
    accOrdBillingMap.put("posOrdBillRefNo", "1000"); // accorderbill.AccBillRefNo
                                                     // = "1000"; //update later
                                                     // //at db
    accOrdBillingMap.put("posOrdBillOrdId", 0); // accorderbill.AccBillOrderID =
                                                // 0;
    accOrdBillingMap.put("posOrdBillOrdNo", ""); // accorderbill.AccBillOrderNo
                                                 // = "";
    accOrdBillingMap.put("posOrdBillTypeId", SalesConstants.POS_ORD_BILL_TYPE_ID); // accorderbill.AccBillTypeID
                                                                                   // =
                                                                                   // 1159;
                                                                                   // //System
                                                                                   // Generate
                                                                                   // Bill
    accOrdBillingMap.put("posOrdBillModeId", SalesConstants.POS_ORD_BILL_MODE_ID); // accorderbill.AccBillModeID
                                                                                   // =
                                                                                   // 1351;
                                                                                   // //SOI
                                                                                   // Bill
                                                                                   // (POS
                                                                                   // New
                                                                                   // Version)
    accOrdBillingMap.put("posOrdBillScheduleId", 0); // accorderbill.AccBillScheduleID
                                                     // = 0;
    accOrdBillingMap.put("posOrdBillSchedulePeriod", 0); // accorderbill.AccBillSchedulePeriod
                                                         // = 0;
    accOrdBillingMap.put("posOrdBillAdjustmentId", 0); // accorderbill.AccBillAdjustmentID
                                                       // = 0;
    accOrdBillingMap.put("posOrdBillScheduleAmt", rtnAmt); // accorderbill.AccBillScheduleAmount
                                                           // =
                                                           // decimal.Parse(totalcharges);
    accOrdBillingMap.put("posOrdBillAdjustmentAmt", 0); // accorderbill.AccBillAdjustmentAmount
                                                        // = 0;
    accOrdBillingMap.put("posOrdBillTaxesAmt", rtnTax); // accorderbill.AccBillTaxesAmount
                                                        // =
                                                        // Convert.ToDecimal(string.Format("{0:0.00}",
                                                        // decimal.Parse(totalcharges)
                                                        // -
                                                        // (System.Convert.ToDecimal(totalcharges)
                                                        // * 100 / 106)));
    accOrdBillingMap.put("posOrdBillNetAmount", rtnAmt); // accorderbill.AccBillNetAmount
                                                         // =
                                                         // decimal.Parse(totalcharges);
    accOrdBillingMap.put("posOrdBillStatus", 1); // accorderbill.AccBillStatus =
                                                 // 1;
    accOrdBillingMap.put("posOrdBillRem", docNoInvoice); // accorderbill.AccBillRemark
                                                         // = ""; //Invoice No.
    accOrdBillingMap.put("userId", params.get("userId"));
    accOrdBillingMap.put("posOrdBillGroupId", 0); // accorderbill.AccBillGroupID
                                                  // = 0;
    accOrdBillingMap.put("posOrdBillTaxCodeId", SalesConstants.POS_ORD_BILL_TAX_CODE_ID); // accorderbill.AccBillTaxCodeID
                                                                                          // =
                                                                                          // 32;
    accOrdBillingMap.put("posOrdBillTaxRate", 0); // accorderbill.AccBillTaxRate
                                                  // = 6;
    accOrdBillingMap.put("posOrdBillAcctCnvr", 0); // TODO ASIS 소스 없음
    accOrdBillingMap.put("posOrdBillCntrctId", 0); // TODO ASIS 소스 없음

    LOGGER.info("############### 5. POS ACC ORDER BILL INSERT START  ################");
    LOGGER.info("############### 5. POS ACC ORDER BILL INSERT param : " + accOrdBillingMap.toString());
    posMapper.insertPosOrderBilling(accOrdBillingMap);
    LOGGER.info("############### 5. POS ACC ORDER BILL INSERT END  ################");

    // 6.
    // *********************************************************************************************************
    // ACC TAX INVOICE MISCELLANEOUS

    Map<String, Object> accTaxInvoiceMiscellaneouMap = new HashMap<String, Object>();
    int accTaxInvMiscSeq = posMapper.getSeqPay0031D();

    accTaxInvoiceMiscellaneouMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq); // InvMiscMaster.TaxInvoiceID
                                                                            // =
                                                                            // 0;
    accTaxInvoiceMiscellaneouMap.put("posTaxInvRefNo", docNoInvoice); // InvMiscMaster.TaxInvoiceRefNo
                                                                      // = "";
                                                                      // //update
                                                                      // later
    accTaxInvoiceMiscellaneouMap.put("posTaxInvSvcNo", docNoPsn); // InvMiscMaster.TaxInvoiceServiceNo
                                                                  // = ""; //SOI
                                                                  // No.
    accTaxInvoiceMiscellaneouMap.put("posTaxInvType", SalesConstants.POS_TAX_INVOICE_TYPE); // InvMiscMaster.TaxInvoiceType
                                                                                            // =
                                                                                            // 142;
                                                                                            // //pos
                                                                                            // new
                                                                                            // version

    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)) { // 1357
                                                                                                             // Other
                                                                                                             // Income
      accTaxInvoiceMiscellaneouMap.put("posTaxInvCustName", posMap.get("insPosCustName")); // InvMiscMaster.TaxInvoiceCustName
                                                                                           // =
                                                                                           // this.txtCustName.Text.Trim();
      accTaxInvoiceMiscellaneouMap.put("posTaxInvCntcPerson", posMap.get("insPosCustName")); // InvMiscMaster.TaxInvoiceContactPerson
                                                                                             // =
                                                                                             // this.txtCustName.Text.Trim();

    } else {
      accTaxInvoiceMiscellaneouMap.put("posTaxInvCustName", nameMAp.get("name")); // InvMiscMaster.TaxInvoiceCustName
                                                                                  // =
                                                                                  // this.txtCustName.Text.Trim();
      accTaxInvoiceMiscellaneouMap.put("posTaxInvCntcPerson", nameMAp.get("name")); // InvMiscMaster.TaxInvoiceContactPerson
                                                                                    // =
                                                                                    // this.txtCustName.Text.Trim();
    }
    accTaxInvoiceMiscellaneouMap.put("posTaxInvTaskId", 0); // InvMiscMaster.TaxInvoiceTaskID
                                                            // = 0;
    accTaxInvoiceMiscellaneouMap.put("posTaxInvUserName", params.get("userName")); // InvMiscMaster.TaxInvoiceRemark
                                                                                   // =
                                                                                   // li.LoginID;
    accTaxInvoiceMiscellaneouMap.put("posTaxInvCharges", rtnCharge); // InvMiscMaster.TaxInvoiceCharges
                                                                     // =
                                                                     // Convert.ToDecimal(string.Format("{0:0.00}",
                                                                     // (decimal.Parse(totalcharges)
                                                                     // * 100 /
                                                                     // 106)));
    accTaxInvoiceMiscellaneouMap.put("posTaxInvTaxes", rtnTax); // InvMiscMaster.TaxInvoiceTaxes
                                                                // =
                                                                // Convert.ToDecimal(string.Format("{0:0.00}",
                                                                // decimal.Parse(totalcharges)
                                                                // -
                                                                // (decimal.Parse(totalcharges)
                                                                // * 100 /
                                                                // 106)));
    accTaxInvoiceMiscellaneouMap.put("posTaxInvTotalCharges", rtnAmt); // InvMiscMaster.TaxInvoiceAmountDue
                                                                       // =
                                                                       // decimal.Parse(totalcharges);
    accTaxInvoiceMiscellaneouMap.put("userId", params.get("userId"));

    // TODO 추후 삭제
    /* Magic Address 미구현 추후 삭제 */
    /*
     * accTaxInvoiceMiscellaneouMap.put("addr1", "");
     * accTaxInvoiceMiscellaneouMap.put("addr2", "");
     * accTaxInvoiceMiscellaneouMap.put("addr3", "");
     * accTaxInvoiceMiscellaneouMap.put("addr4", "");
     * accTaxInvoiceMiscellaneouMap.put("postCode", "");
     * accTaxInvoiceMiscellaneouMap.put("stateName", "");
     * accTaxInvoiceMiscellaneouMap.put("cnty", "");
     */

    LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS INSERT START  ################");
    LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS INSERT param : "
        + accTaxInvoiceMiscellaneouMap.toString());
    posMapper.insertPosTaxInvcMisc(accTaxInvoiceMiscellaneouMap);
    LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS END  ################");
    // 7.
    // *********************************************************************************************************
    // ACC TAX INVOICE MISCELLANEOUS_SUB
    int invItemTypeID = 0;

    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)) { // filter
                                                                                                       // 1352
      invItemTypeID = 1355;
    }
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK)) { // item
                                                                                                        // bank
                                                                                                        // 1353
      invItemTypeID = 1356;
    }
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)) { // other
                                                                                                             // income
      invItemTypeID = 1359;
    }
    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK_HQ)) { // item
                                                                                                           // bank-HQ
      invItemTypeID = 1360;
    }
    for (int idx = 0; idx < basketGrid.size(); idx++) {
      Map<String, Object> invDetailMap = new HashMap<String, Object>();
      invDetailMap = (Map<String, Object>) basketGrid.get(idx);
      int invDetailSeq = posMapper.getSeqPay0032D();

      invDetailMap.put("invDetailSeq", invDetailSeq); // InvMiscD.InvocieItemID
                                                      // = 0;
      invDetailMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq); // InvMiscD.TaxInvoiceID
                                                              // = 0; //update
                                                              // later
      invDetailMap.put("invItemTypeID", invItemTypeID); // InvMiscD.InvoiceItemType
                                                        // = invItemTypeID;
      invDetailMap.put("posTaxInvSubOrdNo", ""); // InvMiscD.InvoiceItemOrderNo
                                                 // = "";
      invDetailMap.put("posTaxInvSubItmPoNo", ""); // InvMiscD.InvoiceItemPONo =
                                                   // "";
      // InvMiscD.InvoiceItemCode =
      // itm.GetDataKeyValue("ItemStkCode").ToString();
      // InvMiscD.InvoiceItemDescription1 =
      // itm.GetDataKeyValue("ItemStkDesc").ToString();
      invDetailMap.put("posTaxInvSubDescSub", ""); // InvMiscD.InvoiceItemDescription2
                                                   // = "";
      invDetailMap.put("posTaxInvSubSerialNo", ""); // InvMiscD.InvoiceItemSerialNo
                                                    // = "";
      // InvMiscD.InvoiceItemQuantity =
      // int.Parse(itm.GetDataKeyValue("ItemQty").ToString());
      // InvMiscD.InvoiceItemUnitPrice =
      // decimal.Parse(itm.GetDataKeyValue("ItemUnitPrice").ToString());
      invDetailMap.put("posTaxInvSubGSTRate", 0); // InvMiscD.InvoiceItemGSTRate
                                                  // = 6;
      // InvMiscD.InvoiceItemGSTTaxes =
      // Convert.ToDecimal(string.Format("{0:0.00}",
      // decimal.Parse(itm["ItemTotalAmt"].Text) -
      // (decimal.Parse(itm["ItemTotalAmt"].Text) * 100 / 106)));
      // InvMiscD.InvoiceItemCharges =
      // Convert.ToDecimal(string.Format("{0:0.00}",
      // (decimal.Parse(itm["ItemTotalAmt"].Text) * 100 / 106)));
      // InvMiscD.InvoiceItemAmountDue =
      // decimal.Parse(itm.GetDataKeyValue("ItemTotalAmt").ToString());

      // TODO 추후 삭제
      /* ### Masic Address 미반영 ### */
      /*
       * invDetailMap.put("posTaxInvSubAddr1", ""); //InvMiscD.InvoiceItemAdd1 =
       * ""; invDetailMap.put("posTaxInvSubAddr2", "");
       * //InvMiscD.InvoiceItemAdd2 = ""; invDetailMap.put("posTaxInvSubAddr3",
       * ""); //InvMiscD.InvoiceItemAdd3 = "";
       * invDetailMap.put("posTaxInvSubAddr4", ""); ////InvMiscD.InvoiceItemAdd3
       * = null; invDetailMap.put("posTaxInvSubPostCode", "");
       * //InvMiscD.InvoiceItemPostCode = "";
       * invDetailMap.put("posTaxInvSubAreaName", ""); // areaName
       * invDetailMap.put("posTaxInvSubStateName", "");
       * //InvMiscD.InvoiceItemStateName = "";
       * invDetailMap.put("posTaxInvSubCntry", "");
       * //InvMiscD.InvoiceItemCountry = "";
       */
      LOGGER.info(
          "############### 7 - " + idx + " POS ACC TAX INVOICE MISCELLANEOUS_SUB  INSERT START  ################");
      LOGGER.info("############### 7 - " + idx + " POS ACC TAX INVOICE MISCELLANEOUS_SUB  INSERT param : "
          + invDetailMap.toString());
      posMapper.insertPosTaxInvcMiscSub(invDetailMap);
      LOGGER.info("############### 7 - " + idx + " POS ACC TAX INVOICE MISCELLANEOUS END  ################");
    }

    // 8.
    // *********************************************************************************************************
    // InvStkRecordCard --> Only For Filter/Spare Part Type

    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)) { // insPosSystemType
                                                                                                       // ==
                                                                                                       // 1352
                                                                                                       // POS_SALES_TYPE_FILTER
                                                                                                       // posMap

      for (int idx = 0; idx < basketGrid.size(); idx++) {

        Map<String, Object> recordlMap = (Map<String, Object>) basketGrid.get(idx);

        // LOG0014D
        int stkRecordSeq = posMapper.getSeqLog0014D();

        recordlMap.put("stkRecordSeq", stkRecordSeq); // invStkCard.SRCardID =
                                                      // 0;
        // TODO brnchId 를 넣을건지 , locId 를 넣을 건지 선택해야함 (현재는 BranchId)
        // Location ID? Branch ID? == Location Id (now)
        // invStkCard.StockID =
        // int.Parse(itm.GetDataKeyValue("ItemStkID").ToString());
        // invStkCard.EntryDate =
        // Convert.ToDateTime(this.dpSalesDate.SelectedDate);
        recordlMap.put("invStkRecordTypeId", SalesConstants.POS_INV_STK_TYPE_ID); // invStkCard.TypeID
                                                                                  // =
                                                                                  // 571;
        recordlMap.put("invStkRecordRefNo", docNoPsn); // invStkCard.RefNo = "";
                                                       // //update later //POS
                                                       // No. 144Doc
        recordlMap.put("invStkRecordOrdId", 0); // invStkCard.SalesOrderId = 0;
        recordlMap.put("invStkRecordItmNo", idx); // invStkCard.ItemNo = count;
        recordlMap.put("invStkRecordSourceId", SalesConstants.POS_INV_SOURCE_ID); // invStkCard.SourceID
                                                                                  // =
                                                                                  // 477;
        recordlMap.put("invStkRecordProjectId", 0); // invStkCard.ProjectID = 0;
        recordlMap.put("invStkRecordBatchNo", 0); // invStkCard.BatchNo = 0;
        // invStkCard.Qty =
        // -int.Parse(itm.GetDataKeyValue("ItemQty").ToString());
        recordlMap.put("invStkRecordCurrId", SalesConstants.POS_INV_CURR_ID); // invStkCard.CurrID
                                                                              // =
                                                                              // 479;
        recordlMap.put("invStkRecordCurrRate", SalesConstants.POS_INV_CURR_RATE); // invStkCard.CurrRate
                                                                                  // =
                                                                                  // 1;
        recordlMap.put("invStkRecordCost", 0); // invStkCard.Cost = 0;
        recordlMap.put("invStkRecordPrice", 0); // invStkCard.Price = 0;
        recordlMap.put("invStkRecordRem", posMap.get("posRemark")); // invStkCard.Remark
                                                                    // =
                                                                    // !string.IsNullOrEmpty(this.txtRemark.Text.Trim())
                                                                    // ?
                                                                    // this.txtRemark.Text.Trim()
                                                                    // : "";
        recordlMap.put("invStkRecordSerialNo", ""); // invStkCard.SerialNo = "";
        recordlMap.put("invStkRecordInstallNo", ""); // invStkCard.InstallNo =
                                                     // "";
        // invStkCard.CostDate = DateTime.Now;
        recordlMap.put("invStkRecordAppTypeId", 0); // invStkCard.AppTypeID = 0;
        recordlMap.put("invStkRecordStkGrade", ""); // invStkCard.StkGrade =
                                                    // string.Empty;
        recordlMap.put("invStkRecordInstallFail", 0); // invStkCard.InstallFail
                                                      // = false;
        recordlMap.put("invStkRecordIsSynch", 0); // invStkCard.IsSynch = false;
        recordlMap.put("invStkRecordEntryMthId", 0); // ENTRY_MTH_ID

        LOGGER.info("############### 8. POS InvStkRecordCard INSERT START  ################");
        LOGGER.info("############### 8. POS InvStkRecordCard INSERT param : " + recordlMap.toString());
        posMapper.insertStkRecord(recordlMap);
        LOGGER.info("############### 8. POS InvStkRecordCard END  ################");

      }
    } // end 8

    // ********************* PAYMENT LOGIC START ********************* //
    // When 'POS SALES' Case
    if ((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf(posMap.get("insPosModuleType")))) { // 2390
                                                                                                                   // --
                                                                                                                   // POS
                                                                                                                   // SALES

      /* params Setting */
      String trxNo = "";
      String worNo = "";
      int trxSeq = 0;
      int groupSeq = 0;

      Map<String, Object> trxMap = new HashMap<String, Object>();

      // DOC(23)
      // TODO 문서 채번 후 미사용
      params.put("docNoId", SalesConstants.POS_DOC_NO_TRX_NO); // (23)
      trxNo = posMapper.getDocNo(params);

      // DOC(3)
      params.put("docNoId", SalesConstants.POS_DOC_NO_WOR_NO); // (3)
      worNo = posMapper.getDocNo(params);

      // Seq
      trxSeq = posMapper.getSeqPay0069D();
      groupSeq = posMapper.getSeqPay0240T();

      // 9.
      // *********************************************************************************************************
      // PAY X

      trxMap.put("trxSeq", trxSeq);
      trxMap.put("trxType", SalesConstants.POS_TRX_TYPE_ID);
      trxMap.put("trxAmt", payFormMap.get("hidTotPayAmt"));
      // trxMap.put("trxNo", trxNo); //doc Number 미사용
      trxMap.put("trxMatchNo", "");

      LOGGER.info("############### 9. POS PAYX INSERT START  ################");
      LOGGER.info("############### 9. POS PAYX INSERT param : " + trxMap.toString());
      posMapper.insertPayTrx(trxMap);
      LOGGER.info("############### 9. POS PAYX END  ################");

      // 10.
      // *********************************************************************************************************
      // PAY M

      Map<String, Object> paymMap = new HashMap<String, Object>();

      int payMseq = posMapper.getSeqPay0064D();

      paymMap.put("payMseq", payMseq);
      paymMap.put("orNo", worNo); // doc
      paymMap.put("salesOrdId", SalesConstants.POS_TEMP_SALES_ORDER_ID); // 0
      paymMap.put("billId", posBillSeq); // accbilling.billId ( payM.BillID =
                                         // accbilling.BillID;)

      // trno = txtTrRefNo
      String trNo = "";
      if (payFormMap.get("payTrRefNo") != null) {
        trNo = String.valueOf(payFormMap.get("payTrRefNo"));
        trNo = trNo.trim().toUpperCase();
      } else {
        trNo = " ";
      }
      paymMap.put("trNo", trNo); // payM.TRNo =
                                 // (!string.IsNullOrEmpty(this.txtTrRefNo.Text.Trim()))
                                 // ? this.txtTrRefNo.Text.ToUpper() : "";
      paymMap.put("typeId", SalesConstants.POS_PAY_MASTER_TYPE_ID); // 577
      paymMap.put("bankChgAmt", SalesConstants.POS_BANK_CHARGE_AMOUNT);
      paymMap.put("bankChgAccId", SalesConstants.POS_BANK_CHARGE_ACCOUNT_ID);
      paymMap.put("collMemId", SalesConstants.POS_COLL_MEMBER_ID);

      // brnchId
      paymMap.put("brnchId", payFormMap.get("payBrnchCode"));

      // Debtor Acc.
      paymMap.put("bankAccId", payFormMap.get("payDebtorAcc"));

      paymMap.put("allowComm", SalesConstants.POS_PAY_ALLOW_COMM);
      paymMap.put("stusCodeId", SalesConstants.POS_PAY_STATUS_ID);

      // userId
      paymMap.put("updUserId", params.get("userId"));

      paymMap.put("syncCheck", SalesConstants.POS_PAY_SYNC_CHECK);
      paymMap.put("thirdPartyCustId", SalesConstants.POS_THIRD_PARTY_CUST_ID);

      // total Amt
      paymMap.put("totAmt", payFormMap.get("hidTotPayAmt"));
      paymMap.put("matchId", SalesConstants.POS_MATCH_ID);

      // userId
      paymMap.put("crtUserId", params.get("userId"));
      paymMap.put("isAllowRevMulti", SalesConstants.POS_IS_ALLOW_REV_MULTY);
      paymMap.put("isGlPostClm", SalesConstants.POS_IS_GL_POST_CLAIM);
      paymMap.put("glPostClmDt", SalesConstants.DEFAULT_DATE);
      paymMap.put("trxSeq", trxSeq); // trxId
      paymMap.put("advMonth", SalesConstants.POS_ADV_MONTH);
      paymMap.put("orderBillId", accOrderBillSeq); // payM.AccBillID =
                                                   // accorderbill.AccBillID;

      // TR Issued Date
      if (payFormMap.get("payTrIssueDate") != null) {
        paymMap.put("trIssuDt", payFormMap.get("payTrIssueDate"));
      } else {
        paymMap.put("trIssuDt", SalesConstants.DEFAULT_DATE);
      }

      paymMap.put("payInvIsGen", SalesConstants.POS_TAX_INVOICE_GENERATED);
      paymMap.put("taxInvcRefNo", docNoInvoice); // payM.TaxInvoiceRefNo =
                                                 // InvoiceNum;
      paymMap.put("svcCntrctId", SalesConstants.POS_SERVICE_CONTRACT_ID);
      paymMap.put("batchPayId", SalesConstants.POS_BATCH_PAYMEMNT_ID);

      LOGGER.info("############### 10. POS PAYM INSERT START  ################");
      LOGGER.info("############### 10. POS PAYM INSERT param : " + paymMap.toString());
      posMapper.insertPayMaster(paymMap);
      LOGGER.info("############### 10. POS PAYM END  ################");

      // Grid == payGrid
      // Grid Size 만큼 for문
      for (int idx = 0; idx < payGrid.size(); idx++) {
        Map<String, Object> paydMap = new HashMap<String, Object>();

        paydMap = (Map<String, Object>) payGrid.get(idx);

        // 11.
        // *********************************************************************************************************
        // PAY D (LOOP)
        // setting
        int posDSeq = 0;
        posDSeq = posMapper.getSeqPay0065D();
        paydMap.put("payItemId", posDSeq);
        paydMap.put("payId", payMseq);

        if (paydMap.get("transactionRefNo") != null && "" != paydMap.get("transactionRefNo")) {
          String payRefNo = "";
          payRefNo = String.valueOf(paydMap.get("transactionRefNo"));
          payRefNo = payRefNo.toUpperCase();
          paydMap.put("transactionRefNo", payRefNo);
        }

        if (paydMap.get("payCrcMode") != null && "" != paydMap.get("payCrcMode")) {
          String payCrcMode = "";
          payCrcMode = String.valueOf(paydMap.get("payCrcMode"));

          if (("ONLINE").equals(payCrcMode)) {
            paydMap.put("payCrcMode", "1");
          } else {
            paydMap.put("payCrcMode", "0");
          }
        } else {
          paydMap.put("payCrcMode", "0");
        }

        if (paydMap.get("payRefDate") == null || paydMap.get("payRefDate") == "") {
          paydMap.put("payRefDate", SalesConstants.DEFAULT_DATE);
        }

        paydMap.put("payItmStusId", SalesConstants.POS_PAY_STATUS_ID);

        paydMap.put("payItmIsLok", SalesConstants.POS_PAY_ITEM_IS_LOCK);
        paydMap.put("payItmIsThirdParty", SalesConstants.POS_PAY_ITEM_IS_THIRD_PARTY);
        paydMap.put("isFundTrnsfr", SalesConstants.POS_IS_FUND_TRANS_FR);
        paydMap.put("skipRecon", SalesConstants.POS_SKIP_RECON);

        LOGGER.info("############### 11 -[" + idx + "]. POS PAYD INSERT START  ################");
        LOGGER.info("############### 11 -[" + idx + "]. POS PAYD INSERT param : " + paydMap.toString());
        posMapper.insertPayDetail(paydMap);
        LOGGER.info("############### 11 -[" + idx + "]. POS PAYD INSERT END  ################");

        // 11.
        // *********************************************************************************************************
        // ACCGLROUTE (LOOP)
        // SUSPENDACCID 와 SETTLEACCID 세팅
        int suspendAccId = 0;
        int settleAccId = 0;

        if (Integer.parseInt(String.valueOf(paydMap.get("payMode"))) == SalesConstants.POS_PAY_METHOD_CASH) { // 105
                                                                                                              // Cash
          suspendAccId = SalesConstants.POS_PAY_SUSPEND_CASH; // 531
          settleAccId = Integer.parseInt(String.valueOf(paydMap.get("payBankAccount")));

        } else if (Integer.parseInt(String.valueOf(paydMap.get("payMode"))) == SalesConstants.POS_PAY_METHOD_CARD) { // 107
                                                                                                                     // Card
          suspendAccId = Integer.parseInt(String.valueOf(paydMap.get("payBankAccount")));

          switch (Integer.parseInt(String.valueOf(paydMap.get("payBankAccount")))) {
            case SalesConstants.POS_ITE_BANK_ACC_99:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_83;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_100:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_90;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_101:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_84;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_103:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_83;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_104:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_86;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_105:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_85;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_106:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_84;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_107:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_88;
              break;
            case SalesConstants.POS_ITE_BANK_ACC_497:
              settleAccId = SalesConstants.POS_SET_SETTLE_ACC_497;
              break;
            default:
              break;
          }// switch end
        } else if (Integer
            .parseInt(String.valueOf(paydMap.get("payMode"))) == SalesConstants.POS_PAY_METHOD_COMMISSION) { // 108
                                                                                                             // commission

          suspendAccId = SalesConstants.POS_PAY_SUSPEND_COMMISSION; // 533
          settleAccId = Integer.parseInt(String.valueOf(paydMap.get("payBankAccount")));

        }

        LOGGER.info("#########################  suspendAccId : " + suspendAccId);
        LOGGER.info("#########################  settleAccId : " + settleAccId);
        Map<String, Object> glrouteMap = new HashMap<String, Object>();

        // SEQ 생성
        int glSeq = posMapper.getSeqPay0009D();

        glrouteMap.put("glSeq", glSeq); // glroute.ID = 0;
        // SYSDATE //glroute.GLPostingDate = DateTime.Now;
        glrouteMap.put("glFisCalDate", SalesConstants.DEFAULT_DATE); // glroute.GLFiscalDate
                                                                     // =
                                                                     // DateTime.Parse(string.Format("{0:dd/MM/yyyy}",
                                                                     // "1900-01-01"));
        glrouteMap.put("glBatchNo", trxSeq); // glroute.GLBatchNo =
                                             // paytrx.TrxID.ToString();
        glrouteMap.put("glBatchTypeDesc", ""); // glroute.GLBatchTypeDesc = "";
        glrouteMap.put("glBatchTotal", payFormMap.get("hidTotPayAmt")); // glroute.GLBatchTotal
                                                                        // =
                                                                        // (double)payM.TotalAmt;
        glrouteMap.put("glReceiptNo", worNo); // glroute.GLReceiptNo = orNo;
        glrouteMap.put("glReceiptTypeId", SalesConstants.POS_RECEIPT_TYPE_ID); // glroute.GLReceiptTypeID
                                                                               // =
                                                                               // 577;
        glrouteMap.put("glReceiptBranchId", payFormMap.get("payBrnchCode")); // glroute.GLReceiptBranchID
                                                                             // =
                                                                             // (int)payM.BranchID;
        glrouteMap.put("glReceiptSettleAccId", settleAccId); // glroute.GLReceiptSettleAccID
                                                             // = SettleAccID;
        glrouteMap.put("glReceiptAccountId", suspendAccId); // glroute.GLReceiptAccountID
                                                            // = SuspendAccID;
        glrouteMap.put("glReceiptItemId", posDSeq); // glroute.GLReceiptItemID =
                                                    // pd.PayItemID;
        glrouteMap.put("glReceiptItemModeId", paydMap.get("payMode")); // glroute.GLReceiptItemModeID
                                                                       // =
                                                                       // (int)pd.PayItemModeID;
        glrouteMap.put("glReverseReceiptItemId", SalesConstants.POS_GL_REVERSE_RECEIPT_ITEM_ID); // glroute.GLReverseReceiptItemID
                                                                                                 // =
                                                                                                 // 0;
        glrouteMap.put("glReceiptItemAmount", paydMap.get("payAmt")); // glroute.GLReceiptItemAmount
                                                                      // =
                                                                      // (double)pd.PayItemAmt;
        glrouteMap.put("glReceiptItemCharges", SalesConstants.POS_GL_RECEIPT_ITEM_CHARGES); // glroute.GLReceiptItemCharges
                                                                                            // =
                                                                                            // 0;
        glrouteMap.put("glReceiptItemRclStatus", SalesConstants.POS_GL_RECEIPT_ITEM_RCL_STATUS); // glroute.GLReceiptItemRCLStatus
                                                                                                 // =
                                                                                                 // "N";
        glrouteMap.put("glConversionStatus", SalesConstants.POS_GL_CONVERSION_STATUS); // glroute.GLConversionStatus
                                                                                       // =
                                                                                       // "Y";

        LOGGER.info("############### 12 -[" + idx + "]. POS ACCGLROUTE INSERT START  ################");
        LOGGER.info("############### 12 -[" + idx + "]. POS ACCGLROUTE INSERT param : " + glrouteMap.toString());
        posMapper.insertAccGlRoute(glrouteMap);
        LOGGER.info("############### 12 -[" + idx + "]. POS ACCGLROUTE INSERT END  ################");

        /****** ADD LOGIC : INSERT PAY0252T // ADD BY LEE SH (2018/01/25) ****/
        Map<String, Object> payTMap = new HashMap<String, Object>();

        payTMap.put("groupSeq", groupSeq);
        payTMap.put("prcssSeq", idx);
        payTMap.put("trxId", trxSeq);
        payTMap.put("payId", payMseq);
        payTMap.put("payItmId", posDSeq);
        payTMap.put("payItmModeId", paydMap.get("payMode"));
        payTMap.put("totAmt", payFormMap.get("hidTotPayAmt"));
        payTMap.put("payItmAmt", paydMap.get("payAmt"));
        payTMap.put("bankChgAmt", paymMap.get("bankChgAmt"));
        payTMap.put("appType", SalesConstants.POS_PAY_APP_TYPE); // POS
        payTMap.put("payRoute", SalesConstants.POS_PAY_ROUTE);
        payTMap.put("payKeyinScrn", SalesConstants.POS_PAY_KEY_IN_SCRN);
        payTMap.put("ldgrType", SalesConstants.POS_PAY_LEDGER_TYPE);

        LOGGER.info("############### 13 -[" + idx + "]. POS PAYT INSERT START  ################");
        LOGGER.info("############### 13 -[" + idx + "]. POS PAYT INSERT param : " + payTMap.toString());
        posMapper.insertPayT(payTMap);
        LOGGER.info("############### 13 -[" + idx + "]. POS PAYT INSERT END  ################");

      } // Loop End
        // PAYMENT GRID 가져옴
    }

    // ********************* PAYMENT LOGIC END ********************* //

    // 10.
    // *********************************************************************************************************
    // BOOKING

    if (String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)) { // POS
                                                                                                       // -
                                                                                                       // FILTER
                                                                                                       // /
                                                                                                       // SPARE
                                                                                                       // PART
                                                                                                       // /
                                                                                                       // MISCELLANEOUS

      Map<String, Object> logPram = new HashMap<String, Object>();

      logPram.put("psno", docNoPsn);
      logPram.put("retype", "REQ");
      logPram.put("pType", "PS01"); // PS02 - cancel
      logPram.put("pPrgNm", "PointOfSales");
      logPram.put("userId", Integer.parseInt(String.valueOf(params.get("userId"))));

      LOGGER.info("############### 10. POS LOGISTIC REQUEST START  ################");
      LOGGER.info("#########  call Procedure Params : " + logPram.toString());

      posMapper.SP_LOGISTIC_POS_SERIAL(logPram);

      String reqResult = String.valueOf(logPram.get("p1"));
      LOGGER.debug("############ Procedure Result :  " + reqResult);
      LOGGER.info("############### 10. POS LOGISTIC REQUEST END  ################");
      //

      LOGGER.info("################################## return value(docNoPsn): " + docNoPsn);
      // retrun Map
      Map<String, Object> rtnMap = new HashMap<String, Object>();
      rtnMap.put("reqDocNo", docNoPsn);
      rtnMap.put("psno", docNoPsn);

      // GetDetailList
      List<EgovMap> revDetList = null;
      rtnMap.put("rcvStusId", SalesConstants.POS_DETAIL_NON_RECEIVE);
      revDetList = posMapper.getPosItmIdListByPosNo(rtnMap);
      LOGGER.info("revDetList : " + revDetList);
      for (int idx = 0; idx < revDetList.size(); idx++) {

        // GI Call Procedure
        Map<String, Object> giMap = new HashMap<String, Object>();

        giMap.put("psno", docNoPsn);
        giMap.put("retype", "COM");
        giMap.put("pType", "PS01");
        giMap.put("posItmId", revDetList.get(idx).get("posItmId"));
        giMap.put("pPrgNm", "PointOfSales");
        giMap.put("userId", params.get("userId"));

        LOGGER.info("############### 11. POS GI COMPLETE START : " + idx + "  ################");
        LOGGER.info("#########  call Procedure Params : " + giMap.toString());

        posMapper.SP_LOGISTIC_POS_SERIAL(giMap);

        reqResult = String.valueOf(giMap.get("p1"));
        LOGGER.info("rtnResult : " + reqResult);
        LOGGER.info("############### 11. POS GI COMPLETE  END : " + idx + " ################");

      }

      rtnMap.put("logError", reqResult);

      // KR-OHK Barcode Save Start
      Map<String, Object> adMap = new HashMap<String, Object>();

      adMap.put("reqstNo", docNoPsn);
      adMap.put("callGbn", "POS");
      adMap.put("userId", params.get("userId"));

      posMapper.SP_SALES_BARCODE_SAVE(adMap);

      String errCode = (String) adMap.get("pErrcode");
      String errMsg = (String) adMap.get("pErrmsg");

      LOGGER.debug(">>>>>>>>>>>SP_SALES_BARCODE_SAVE ERROR CODE : " + errCode);
      LOGGER.debug(">>>>>>>>>>>SP_SALES_BARCODE_SAVE ERROR MSG: " + errMsg);

      // pErrcode : 000 = Success, others = Fail
      if (!"000".equals(errCode)) {
        throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
      }
      // Barcode Save End

      return rtnMap;

    }

    // KR-OHK Barcode Save Start
    Map<String, Object> adMap = new HashMap<String, Object>();

    adMap.put("reqstNo", docNoPsn);
    adMap.put("callGbn", "POS");
    adMap.put("userId", params.get("userId"));

    posMapper.SP_SALES_BARCODE_SAVE(adMap);

    String errCode = (String) adMap.get("pErrcode");
    String errMsg = (String) adMap.get("pErrmsg");

    LOGGER.debug(">>>>>>>>>>>SP_SALES_BARCODE_SAVE ERROR CODE : " + errCode);
    LOGGER.debug(">>>>>>>>>>>SP_SALES_BARCODE_SAVE ERROR MSG: " + errMsg);

    // pErrcode : 000 = Success, others = Fail
    if (!"000".equals(errCode)) {
      throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
    }
    // Barcode Save End

    LOGGER.info("##################### POS Request Success!!! ######################################");
    LOGGER.info("##################### POS Request Success!!! ######################################");
    LOGGER.info("##################### POS Request Success!!! ######################################");

    // retrun Map
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("reqDocNo", docNoPsn);
    rtnMap.put("logError", "000");

    return rtnMap;
  }

  @Override
  @Transactional
  public EgovMap insertPosReversalSerial(Map<String, Object> params) throws Exception {

    /* ########### get Params ############### */
    double rtnAmt = 0;
    double rtnCharge = 0;
    double rtnTax = 0;
    double rtnDisc = 0;
    double tempBillAmt = 0;

    String posRefNo = ""; // SOI no. (144)
    String voidNo = ""; // Void no. (112)
    String rptNo = ""; // RD no. (18)
    String cnno = ""; // CN-New (134)

    int posMasterSeq = 0;
    int posDetailDuducSeq = 0;
    int posBillSeq = 0;
    int memoAdjSeq = 0;
    int noteSeq = 0;
    int miscSubSeq = 0;
    int noteSubSeq = 0;
    int ordVoidSeq = 0;
    int ordVoidSubSeq = 0;
    int stkSeq = 0;
    int groupSeq = 0;

    String giResult = "";
    String reqResult = "";

    /*
     * ################################### Get Doc No
     * #############################
     */

    params.put("docNoId", SalesConstants.POS_DOC_NO_PSN_NO); // (144)
    posRefNo = posMapper.getDocNo(params);

    params.put("docNoId", SalesConstants.POS_DOC_NO_VOID_NO); // (112)
    voidNo = posMapper.getDocNo(params);

    params.put("docNoId", SalesConstants.POS_DOC_NO_RD_NO); // (18)
    rptNo = posMapper.getDocNo(params);

    params.put("docNoId", SalesConstants.POS_DOC_NO_CN_NEW_NO); // (134)
    cnno = posMapper.getDocNo(params);

    // 1.
    // *********************************************************************************************************
    // POS MASTER

    // Price and Qty Setting

    rtnAmt = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotAmt")));
    rtnCharge = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotChrg")));
    rtnTax = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotTxs")));
    rtnDisc = -1 * Double.parseDouble(String.valueOf(params.get("rePosTotDscnt")));

    // Seq
    posMasterSeq = posMapper.getSeqSal0057D(); // master Sequence
    Map<String, Object> posMap = new HashMap<String, Object>();

    posMap.put("posMasterSeq", posMasterSeq); // posId = 0 -- 시퀀스
    posMap.put("docNoPsn", posRefNo); // posNo = 0 --문서채번
    posMap.put("posBillId", SalesConstants.POS_BILL_ID); // pos Bill Id // 0

    posMap.put("posCustName", params.get("rePosCustName")); // posCustName =
                                                            // other Income만 사용함
                                                            // .. 그러면 나머지는??
    posMap.put("insPosModuleType", params.get("rePosModuleTypeId"));
    posMap.put("insPosSystemType", SalesConstants.POS_SALES_TYPE_REVERSAL); // 1361
    posMap.put("posTotalAmt", rtnAmt);
    posMap.put("posCharge", rtnCharge);
    posMap.put("posTaxes", rtnTax);
    posMap.put("posDiscount", rtnDisc);
    posMap.put("hidLocId", params.get("rePosWhId"));
    posMap.put("posRemark", params.get("reversalRem"));
    posMap.put("posMtchId", params.get("rePosId")); // pos Old ID
    posMap.put("salesmanPopId", params.get("rePosMemId"));
    posMap.put("posCustomerId", SalesConstants.POS_CUST_ID); // 107205
    posMap.put("userId", params.get("userId"));

    /*
     * if(params.get("userDeptId") == null){ params.put("userDeptId", 0); }
     * posMap.put("userDeptId", params.get("userDeptId"));
     */
    posMap.put("userDeptId", 0);
    if (params.get("userDeptId") == null) {
      params.put("userDeptCode", " ");
    }
    posMap.put("userDeptCode", params.get("userDeptId"));
    posMap.put("crAccId", params.get("rePosCrAccId"));
    posMap.put("drAccId", params.get("rePosDrAccId"));
    posMap.put("posReason", params.get("rePosResnId"));
    posMap.put("cmbWhBrnchIdPop", params.get("rePosBrnchId")); // Brnch
    posMap.put("recvDate", params.get("rePosRcvDt"));
    posMap.put("posStusId", params.get("rePosStusId"));

    if (params.get("rePosModuleTypeId").equals(SalesConstants.POS_SALES_MODULE_TYPE_OTH)) {
      posMap.put("chkOth", SalesConstants.POS_OTH_CHECK_PARAM);
      posMap.put("getAreaId", params.get("getAreaId"));
      posMap.put("addrDtl", params.get("addrDtl"));
      posMap.put("streetDtl", params.get("streetDtl"));
    }

    // Pos Master Insert
    LOGGER.info("############### 1. POS MASTER REVERSAL INSERT START  ################");
    LOGGER.info("############### 1. POS MASTER REVERSAL INSERT param : " + posMap.toString());
    posMapper.insertPosReversalMaster(posMap);
    LOGGER.info("############### 1. POS MASTER REVERSAL INSERT END  ################");

    // 2.
    // *********************************************************************************************************
    // POS DETAIL

    List<EgovMap> oldDetailList = null;
    oldDetailList = posMapper.getOldDetailList(params); // Old Pos Id == param
    // old pos id 로 디테일 리스트 불러옴
    if (oldDetailList != null && oldDetailList.size() > 0) { // for (old List)

      for (int idx = 0; idx < oldDetailList.size(); idx++) {

        EgovMap revDetailMap = null;
        double tempTot = 0;
        double tempChrg = 0;
        double tempTxs = 0;
        int tempQty = 0;

        revDetailMap = oldDetailList.get(idx); // map 생성 --parameter // params
                                               // setting >> old List.get(i) >>
                                               // Map 에 put

        posDetailDuducSeq = posMapper.getSeqSal0058D(); // detail Sequence

        // detail 생성 ....
        revDetailMap.put("posDetailDuducSeq", posDetailDuducSeq); // seq
        revDetailMap.put("posMasterSeq", posMasterSeq); // master Seq

        tempQty = Integer.parseInt(String.valueOf(revDetailMap.get("posItmQty")));
        tempQty = -1 * tempQty;
        revDetailMap.put("posDetailQty", tempQty);

        tempTot = Double.parseDouble(String.valueOf(revDetailMap.get("posItmTot")));
        tempTot = -1 * tempTot;
        revDetailMap.put("posDetailTotal", tempTot);

        tempChrg = Double.parseDouble(String.valueOf(revDetailMap.get("posItmChrg")));
        tempChrg = -1 * tempChrg;
        revDetailMap.put("posDetailCharge", tempChrg);

        tempTxs = Double.parseDouble(String.valueOf(revDetailMap.get("posItmTxs")));
        tempTxs = -1 * tempTxs;
        revDetailMap.put("posDetailTaxs", tempTxs);

        revDetailMap.put("posRcvStusId", SalesConstants.POS_DETAIL_NON_RECEIVE); // RCV_STUS_ID
                                                                                 // ==
                                                                                 // 96
                                                                                 // (Non
                                                                                 // Receive)
        revDetailMap.put("userId", params.get("userId"));

        revDetailMap.put("locId", params.get("rePosBrnchId"));


        if (revDetailMap != null) {
          LOGGER.info("############### 2 - [" + idx + "]  POS DETAIL REVERSAL INSERT START  ################");
          LOGGER
              .info("############### 2 - [" + idx + "]  POS DETAIL REVERSAL INSERT param : " + revDetailMap.toString());
          posMapper.insertPosReversalDetail(revDetailMap);
          posMapper.updateLOG0106MDetail(revDetailMap);
          LOGGER.info("############### 2 - [" + idx + "]  POS DETAIL REVERSAL INSERT END  ################");
        }
      }
      // 2 - 1 .
      // *********************************************************************************************************
      // POS DETAIL
      List<EgovMap> oldSerialList = null;
      oldSerialList = posMapper.chkOldReqSerial(params);

      if (oldSerialList != null && oldSerialList.size() > 0) {
        // Serial Insert
        for (int idx = 0; idx < oldSerialList.size(); idx++) {
          int serialSeq = posMapper.getSeqSal0147M();
          EgovMap oldSerialMap = oldSerialList.get(idx);

          Map<String, Object> serialMap = new HashMap<String, Object>();

          serialMap.put("serialSeq", serialSeq);
          serialMap.put("posMasterSeq", posMasterSeq);
          serialMap.put("stkId", oldSerialMap.get("posItmStockId")); // POS_ITM_STOCK_ID
          serialMap.put("serialNo", oldSerialMap.get("posSerialNo")); // POS_SERIAL_NO
          serialMap.put("userId", params.get("userId"));

          LOGGER.info("############### 2 - Serial - " + idx + "  POS SERIAL INSERT START  ################");
          LOGGER.info("############### 2 - Serial - " + idx + "  POS SERIAL INSERT param : " + serialMap.toString());
          posMapper.insertSerialNo(serialMap);
          LOGGER.info("############### 2 - Serial - " + idx + "  POS SERIAL INSERT END  ################");

        }
      }
    }

    EgovMap billInfoMap = null;
    billInfoMap = posMapper.getBillInfo(params);

    if (billInfoMap != null) {
      // 3.
      // *********************************************************************************************************
      // ACC BILLING
      tempBillAmt = Double.parseDouble(String.valueOf(billInfoMap.get("billAmt")));
      tempBillAmt = -1 * tempBillAmt;

      posBillSeq = posMapper.getSeqPay0007D(); // seq

      billInfoMap.put("billAmt", tempBillAmt);
      billInfoMap.put("posBillSeq", posBillSeq);
      billInfoMap.put("docNoPsn", posRefNo); // posNo = 0 --문서채번
      billInfoMap.put("userId", params.get("userId"));

      // insert
      LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE START  ################");
      LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE PARAM : " + billInfoMap.toString());
      posMapper.insertPosReversalBilling(billInfoMap);
      LOGGER.info("############### 3. POS  REVERSAL  ACC BILLING UPDATE END  ################");
      // 4.
      // *********************************************************************************************************
      // POS MASTER UPDATE BILL_ID
      // posMaster 의 만들어진 시퀀스 번호가 조건일때 posBillId == accBilling 의 시퀀스 ()
      Map<String, Object> posUpMap = new HashMap<String, Object>();
      posUpMap.put("posBillSeq", posBillSeq);
      posUpMap.put("posMasterSeq", posMasterSeq);
      LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER START  ################");
      LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER param : " + posUpMap.toString());
      posMapper.updatePosMasterPosBillId(posUpMap);
      LOGGER.info("############### 4. POS  REVERSAL  BILL_ID UPDATE TO MASTER END  ################");

    }

    EgovMap taxInvMap = null;
    EgovMap getAccMap = null;
    taxInvMap = posMapper.getTaxInvoiceMisc(params); // PAY0031D miscM //
                                                     // MISC(M) MASTER

    if (taxInvMap != null) {
      // 5.
      // *********************************************************************************************************
      // ACC ORDER BILL
      Map<String, Object> accInfoMap = new HashMap<String, Object>();
      accInfoMap.put("taxInvcRefNo", taxInvMap.get("taxInvcRefNo"));

      getAccMap = posMapper.getAccOrderBill(accInfoMap); // 인서트 칠 인포메이션
                                                         // ACC_BILL_ID //

      if (getAccMap != null) {

        Map<String, Object> accOrdUpMap = new HashMap<String, Object>();

        accOrdUpMap.put("accBillId", getAccMap.get("accBillId"));
        accOrdUpMap.put("accBillStatus", SalesConstants.POS_ACC_BILL_STATUS); // 74
        accOrdUpMap.put("accBillTaskId", SalesConstants.POS_ACC_BILL_TASK_ID);

        LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE START  ################");
        LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE PARAM  : " + accOrdUpMap.toString());
        posMapper.updateAccOrderBillingWithPosReversal(accOrdUpMap);
        LOGGER.info("############### 5. POS ACC ORDER BILL REVERSAL UPDATE END  ################");
      }
      // 6.
      // *********************************************************************************************************
      // INVOICE ADJUSTMENT (MASTER)

      Map<String, Object> adjMap = new HashMap<String, Object>();

      memoAdjSeq = posMapper.getSeqPay0011D();

      adjMap.put("memoAdjSeq", memoAdjSeq);
      adjMap.put("memoAdjRefNo", cnno); // 134 //InvAdjM.MemoAdjustRefNo = "";
                                        // //update later
      adjMap.put("memoAdjReptNo", rptNo); // 18 //InvAdjM.MemoAdjustReportNo =
                                          // ""; //update later
      adjMap.put("memoAdjTypeId", SalesConstants.POS_INV_ADJM_MEMO_TYPE_ID); // InvAdjM.MemoAdjustTypeID
                                                                             // =
                                                                             // 1293;
                                                                             // //Type
                                                                             // -
                                                                             // CN
      adjMap.put("memoAdjInvNo", taxInvMap.get("taxInvcRefNo")); // TAX_INVC_REF_NO
                                                                 // InvAdjM.MemoAdjustInvoiceNo
                                                                 // = "";
                                                                 // //update
                                                                 // later-InvoiceNo
                                                                 // BR68..
      adjMap.put("memoAdjInvTypeId", SalesConstants.POS_INV_ADJM_MEMO_INVOICE_TYPE_ID); // InvAdjM.MemoAdjustInvoiceTypeID
                                                                                        // =
                                                                                        // 128;
                                                                                        // //
                                                                                        // Invoice-Miscellaneous
      adjMap.put("memoAdjStatusId", SalesConstants.POS_INV_ADJM_MEMO_STATUS_ID); // InvAdjM.MemoAdjustStatusID
                                                                                 // =
                                                                                 // 4;
      adjMap.put("memoAdjReasonId", SalesConstants.POS_INV_ADJM_MEMO_RESN_ID); // InvAdjM.MemoAdjustReasonID
                                                                               // =
                                                                               // 2038;
                                                                               // //
                                                                               // Invoice
                                                                               // Reversal
      adjMap.put("memoAdjRem", params.get("reversalRem")); // rem
                                                           // InvAdjM.MemoAdjustRemark
                                                           // =
                                                           // this.txtReversalRemark.Text.Trim();
      adjMap.put("memoAdjTotTxs", taxInvMap.get("taxInvcTxs")); // TAX_INVC_TXS
                                                                // InvAdjM.MemoAdjustTaxesAmount
                                                                // =
                                                                // miscM.TaxInvoiceTaxes;
      adjMap.put("memoAdjTotAmt", taxInvMap.get("taxInvcAmtDue")); // TAX_INVC_AMT_DUE
                                                                   // InvAdjM.MemoAdjustTotalAmount
                                                                   // =
                                                                   // miscM.TaxInvoiceAmountDue;
      adjMap.put("userId", params.get("userId"));

      // insert
      LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT START  ################");
      LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT PARAM : " + adjMap.toString());
      posMapper.insertInvAdjMemo(adjMap);
      LOGGER.info("############### 6. POS INVOICE ADJUSTMENT (MASTER) REVERSAL INSERT END  ################");

      // 7.
      // *********************************************************************************************************
      // ACC TAX DEBIT CREDIT NOTE

      Map<String, Object> noteMap = new HashMap<String, Object>();

      noteSeq = posMapper.getSeqPay0027D();

      noteMap.put("noteSeq", noteSeq); // seq
      noteMap.put("memoAdjSeq", memoAdjSeq); // dcnM.NoteEntryID =
                                             // InvAdjM.MemoAdjustID;
      noteMap.put("noteTypeId", SalesConstants.POS_NOTE_TYPE_ID); // dcnM.NoteTypeID
                                                                  // = 1293;
                                                                  // //CN
      noteMap.put("noteGrpNo", taxInvMap.get("taxInvcSvcNo")); // dcnM.NoteGroupNo
                                                               // =
                                                               // miscM.TaxInvoiceServiceNo;
                                                               // TAX_INVC_SVC_NO
      noteMap.put("noteRefNo", cnno); // dcnM.NoteRefNo =
                                      // InvAdjM.MemoAdjustRefNo;
      noteMap.put("noteRefDate", taxInvMap.get("taxInvcRefDt")); // TAX_INVC_REF_DT
                                                                 // //dcnM.NoteRefDate
                                                                 // =
                                                                 // miscM.TaxInvoiceRefDate;
      noteMap.put("noteInvNo", taxInvMap.get("taxInvcRefNo")); // dcnM.NoteInvoiceNo
                                                               // =
                                                               // InvAdjM.MemoAdjustInvoiceNo;
      noteMap.put("noteInvTypeId", SalesConstants.POS_NOTE_INVOICE_TYPE_ID); // dcnM.NoteInvoiceTypeID
                                                                             // =
                                                                             // 128;
                                                                             // //MISC
      noteMap.put("noteInvCustName", taxInvMap.get("taxInvcCustName")); // dcnM.NoteCustName
                                                                        // =
                                                                        // miscM.TaxInvoiceCustName;
                                                                        // //TAX_INVC_CUST_NAME,
      noteMap.put("noteCntcPerson", taxInvMap.get("taxInvcCntcPerson")); // dcnM.NoteContatcPerson
                                                                         // =
                                                                         // miscM.TaxInvoiceContactPerson;
                                                                         // //TAX_INVC_CNTC_PERSON,
      /*
       * dcnM.NoteAddress1 = miscM.TaxInvoiceAddress1; dcnM.NoteAddress2 =
       * miscM.TaxInvoiceAddress2; dcnM.NoteAddress3 = miscM.TaxInvoiceAddress3;
       * dcnM.NoteAddress4 = miscM.TaxInvoiceAddress4; dcnM.NotePostCode =
       * miscM.TaxInvoicePostCode; dcnM.NoteAreaName = ""; dcnM.NoteStateName =
       * miscM.TaxInvoiceStateName; dcnM.NoteCountryName =
       * miscM.TaxInvoiceCountry;
       */
      noteMap.put("noteInvTxs", taxInvMap.get("taxInvcTxs")); // dcnM.NoteTaxes
                                                              // =
                                                              // miscM.TaxInvoiceTaxes;
      noteMap.put("noteInvChrg", taxInvMap.get("taxInvcChrg")); // dcnM.NoteCharges
                                                                // =
                                                                // miscM.TaxInvoiceCharges;
                                                                // //
                                                                // TAX_INVC_CHRG,
      noteMap.put("noteInvAmt", taxInvMap.get("taxInvcAmtDue")); // dcnM.NoteAmountDue
                                                                 // =
                                                                 // miscM.TaxInvoiceAmountDue;

      String soRem = String.valueOf(taxInvMap.get("taxInvcSvcNo"));
      noteMap.put("noteRem", SalesConstants.POS_REM_SOI_COMMENT + soRem); // dcnM.NoteRemark
                                                                          // =
                                                                          // "SOI
                                                                          // Reversal
                                                                          // - "
                                                                          // +
                                                                          // miscM.TaxInvoiceServiceNo;
      noteMap.put("noteStatusId", SalesConstants.POS_NOTE_STATUS_ID); // dcnM.NoteStatusID
                                                                      // = 4;
      noteMap.put("userId", params.get("userId"));

      LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT START  ################");
      LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT PARAM :  " + noteMap.toString());
      posMapper.insertTaxDebitCreditNote(noteMap);
      LOGGER.info("############### 7. POS ACC TAX DEBIT CREDIT NOTE REVERSAL INSERT END  ################");

      Map<String, Object> miscSubMap = new HashMap<String, Object>();
      miscSubMap.put("taxInvcId", taxInvMap.get("taxInvcId"));
      List<EgovMap> miscSubList = null;
      miscSubList = posMapper.getMiscSubList(miscSubMap);

      if (null != miscSubList && miscSubList.size() > 0) {

        for (int idx = 0; idx < miscSubList.size(); idx++) {
          // 8.
          // *********************************************************************************************************
          // INVOICE ADJUSTMENT SUB
          EgovMap tempSubMap = null;
          tempSubMap = miscSubList.get(idx);

          miscSubSeq = posMapper.getSeqPay0012D();
          Map<String, Object> accInvSubMap = new HashMap<String, Object>();
          accInvSubMap.put("miscSubSeq", miscSubSeq);
          accInvSubMap.put("memoAdjSeq", memoAdjSeq); // memoAdjSeq
          accInvSubMap.put("memoSubItmInvItmId", tempSubMap.get("invcItmId")); // INVC_ITM_ID
          accInvSubMap.put("memoSubItmInvItmQty", tempSubMap.get("invcItmQty")); // INVC_ITM_QTY

          accInvSubMap.put("memoSubItmCrditAccId", params.get("rePosCrAccId"));
          accInvSubMap.put("memoSubItmDebtAccId", params.get("rePosDrAccId"));
          accInvSubMap.put("memoSubItmTaxCodeId", getAccMap.get("accBillTaxCodeId"));
          accInvSubMap.put("memoSubItmStusId", SalesConstants.POS_MEMO_ITM_STATUS_ID); // 1
          accInvSubMap.put("memoSubItmRem", params.get("reversalRem")); //// InvAdjM.MemoAdjustRemark;

          accInvSubMap.put("memoSubItmInvItmGSTRate", tempSubMap.get("invcItmGstRate")); // INVC_ITM_GST_RATE
          accInvSubMap.put("memoSubItmInvItmCharges", tempSubMap.get("invcItmChrg")); // INVC_ITM_CHRG
          accInvSubMap.put("memoSubItmInvItmTaxes", tempSubMap.get("invcItmGstTxs")); // INVC_ITM_GST_TXS
          accInvSubMap.put("memoSubItmInvItmAmount", tempSubMap.get("invcItmAmtDue")); // INVC_ITM_AMT_DUE

          LOGGER.info(
              "############### 8 - [" + idx + "] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT START  ################");
          LOGGER.info("############### 8 - [" + idx + "] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT PARAM : "
              + accInvSubMap.toString());
          posMapper.insertInvAdjMemoSub(accInvSubMap);
          LOGGER.info(
              "############### 8 - [" + idx + "] POS INVOICE ADJUSTMENT SUB REVERSAL INSERT END  ################");

          // 9.
          // *********************************************************************************************************
          // ACC TAX DEBIT CREDIT NOTE SUB

          Map<String, Object> noteSubMap = new HashMap<String, Object>();
          noteSubSeq = posMapper.getSeqPay0028D();

          noteSubMap.put("noteSubSeq", noteSubSeq);
          noteSubMap.put("noteSeq", noteSeq); // dcnS.NoteID = dcnM.NoteID;
          noteSubMap.put("noteSubItmId", tempSubMap.get("invcItmId")); // dcnS.NoteItemInvoiceItemID
                                                                       // =
                                                                       // miscSub.InvocieItemID;
          noteSubMap.put("noteSubOrdNo", tempSubMap.get("invcItmOrdNo")); // dcnS.NoteItemOrderNo
                                                                          // =
                                                                          // miscSub.InvoiceItemOrderNo;
          noteSubMap.put("noteSubItmProductModel", tempSubMap.get("invcItmDesc1")); // dcnS.NoteItemProductModel
                                                                                    // =
                                                                                    // miscSub.InvoiceItemDescription1;
          noteSubMap.put("noteSubItmSerialNo", tempSubMap.get("invcItmSerialNo")); // dcnS.NoteItemSerialNo
                                                                                   // =
                                                                                   // miscSub.InvoiceItemSerialNo;
          noteSubMap.put("noteSubItmInstDt", tempSubMap.get("invcItmInstallDt")); // dcnS.NoteItemInstallationDate
                                                                                  // =
                                                                                  // miscSub.InvoiceItemInstallDate;
          /*
           * dcnS.NoteItemAdd1 = miscSub.InvoiceItemAdd1; dcnS.NoteItemAdd2 =
           * miscSub.InvoiceItemAdd2; dcnS.NoteItemAdd3 =
           * miscSub.InvoiceItemAdd3; dcnS.NoteItemAdd4 =
           * miscSub.InvoiceItemAdd4; dcnS.NoteItemPostcode =
           * miscSub.InvoiceItemPostCode; dcnS.NoteItemAreaName =
           * miscSub.InvoiceItemAreaName; dcnS.NoteItemStateName =
           * miscSub.InvoiceItemStateName; dcnS.NoteItemCountry =
           * miscSub.InvoiceItemCountry;
           */
          noteSubMap.put("noteSubItmQty", tempSubMap.get("invcItmQty")); // dcnS.NoteItemQuantity
                                                                         // =
                                                                         // miscSub.InvoiceItemQuantity;
          noteSubMap.put("noteSubItmUnitPrc", tempSubMap.get("invcItmUnitPrc")); // dcnS.NoteItemUnitPrice
                                                                                 // =
                                                                                 // miscSub.InvoiceItemUnitPrice;
          noteSubMap.put("noteSubItmGstRate", tempSubMap.get("invcItmGstRate")); // dcnS.NoteItemGSTRate
                                                                                 // =
                                                                                 // miscSub.InvoiceItemGSTRate;
          noteSubMap.put("noteSubItmGstTxs", tempSubMap.get("invcItmGstTxs")); // dcnS.NoteItemGSTTaxes
                                                                               // =
                                                                               // miscSub.InvoiceItemGSTTaxes;
          noteSubMap.put("noteSubItmChrg", tempSubMap.get("invcItmChrg")); // dcnS.NoteItemCharges
                                                                           // =
                                                                           // miscSub.InvoiceItemCharges;
          noteSubMap.put("noteSubItmDueAmt", tempSubMap.get("invcItmAmtDue")); // dcnS.NoteItemDueAmount
                                                                               // =
                                                                               // miscSub.InvoiceItemAmountDue;

          LOGGER.info("############### 9 - [" + idx
              + "] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT START  ################");
          LOGGER.info("############### 9 - [" + idx + "] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT PARAM : "
              + noteSubMap.toString());
          posMapper.insertTaxDebitCreditNoteSub(noteSubMap);
          LOGGER.info("############### 9 - [" + idx
              + "] POS ACC TAX DEBIT CREDIT NOTE SUB REVERSAL INSERT END  ################");
        }
      }
    } // taxInvMap not null (miscM)

    if (SalesConstants.POS_SALES_TYPE_FILTER.equals(String.valueOf(params.get("rePosSysTypeId")))) { // 1352
                                                                                                     // filter
                                                                                                     // &
                                                                                                     // spare
                                                                                                     // part
      Map<String, Object> stkMap = new HashMap<String, Object>();
      List<EgovMap> stkList = null;

      stkMap.put("rePosNo", params.get("rePosNo"));
      stkList = posMapper.selectStkCardRecordList(stkMap);

      if (stkList != null && stkList.size() > 0) {
        for (int idx = 0; idx < stkList.size(); idx++) {
          EgovMap reStkMap = null;
          reStkMap = stkList.get(idx);

          stkSeq = posMapper.getSeqLog0014D();

          reStkMap.put("stkSeq", stkSeq);
          reStkMap.put("posRefNo", posRefNo); // irc.RefNo = posRefNo;

          int stkTempQty = Integer.parseInt(String.valueOf(reStkMap.get("qty")));
          stkTempQty = -1 * stkTempQty;
          reStkMap.put("stkTempQty", stkTempQty); // irc.Qty = -1 * irc.Qty;

          reStkMap.put("stkRem", SalesConstants.POS_REM_SOI_COMMENT_INV_VOID + String.valueOf(params.get("rePosNo")));

          LOGGER
              .info("############### 12 - [" + idx + "] POS STOCK RECORD CARD REVERSAL INSERT START  ################");
          LOGGER.info("############### 12 - [" + idx + "] POS STOCK RECORD CARD REVERSAL INSERT PARAM : "
              + reStkMap.toString());
          posMapper.insertStkCardRecordReversal(reStkMap);
          LOGGER.info("############### 12 - [" + idx + "] POS STOCK RECORD CARD REVERSAL INSERT END  ################");

        }
      }
    }

    // Request
    Map<String, Object> bookMap = new HashMap<String, Object>();

    bookMap.put("psno", posRefNo);
    bookMap.put("retype", "REQ");
    bookMap.put("pType", "PS02"); // PS02 - cancel
    bookMap.put("pPrgNm", "PointOfSales");
    bookMap.put("userId", Integer.parseInt(String.valueOf(params.get("userId"))));

    LOGGER.info("############### 18. POS Booking Reverse  START  ################");
    LOGGER.info("#########  call Procedure Params : " + bookMap.toString());
    posMapper.SP_LOGISTIC_POS_SERIAL(bookMap);
    reqResult = String.valueOf(bookMap.get("p1"));
    LOGGER.debug("############ Procedure Result :  " + reqResult);
    LOGGER.info("############### 18. POS Booking Reverse  END  ################");

    if (!"000".equals(reqResult)) { // Err
      return null;
    }

    // GetDetailList
    List<EgovMap> revDetList = null;
    bookMap.put("rcvStusId", SalesConstants.POS_DETAIL_NON_RECEIVE);
    revDetList = posMapper.getPosItmIdListByPosNo(bookMap);
    LOGGER.info("@@@@@@@@@@@@@@@@@@@@@@@@@@ revDetList : " + revDetList);
    for (int idx = 0; idx < revDetList.size(); idx++) {

      // GI Call Procedure
      Map<String, Object> giMap = new HashMap<String, Object>();

      giMap.put("psno", posRefNo);
      giMap.put("retype", "COM");
      giMap.put("pType", "PS01");
      giMap.put("posItmId", revDetList.get(idx).get("posItmId"));
      giMap.put("pPrgNm", "PointOfSales");
      giMap.put("userId", params.get("userId"));

      LOGGER.info("############### 19. POS GI Reverse  START  ################");
      LOGGER.info("#########  call Procedure Params : " + giMap.toString());
      posMapper.SP_LOGISTIC_POS_SERIAL(giMap);
      giResult = String.valueOf(giMap.get("p1"));
      LOGGER.info("@@@@@@@@@@@@@@@@@@@@@@@@@@ rtnResult : " + giResult);
      LOGGER.info("############### 19. POS GI Reverse  END  ################");

      if (!"000".equals(giResult)) { // Err
        return null;
      }
    }

    // KR-OHK Barcode Save Start
    Map<String, Object> adMap = new HashMap<String, Object>();

    adMap.put("reqstNo", params.get("rePosNo"));
    adMap.put("callGbn", "POS_REVERSE");
    adMap.put("userId", params.get("userId"));

    posMapper.SP_SALES_BARCODE_SAVE(adMap);

    String errCode = (String) adMap.get("pErrcode");
    String errMsg = (String) adMap.get("pErrmsg");

    LOGGER.debug(">>>>>>>>>>>SP_SALES_BARCODE_SAVE ERROR CODE : " + errCode);
    LOGGER.debug(">>>>>>>>>>>SP_SALES_BARCODE_SAVE ERROR MSG: " + errMsg);

    // pErrcode : 000 = Success, others = Fail
    if (!"000".equals(errCode)) {
      throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
    }
    // Barcode Save End

    // Success
    EgovMap rtnMap = new EgovMap();
    rtnMap.put("posRefNo", posRefNo);
    return rtnMap;

  }

  @Override
  public List<EgovMap> selectLoyaltyRewardPointList(Map<String, Object> params) throws Exception {
    return posMapper.selectLoyaltyRewardPointList(params);
  }

  @Override
  public List<EgovMap> selectLoyaltyRewardPointDetails(Map<String, Object> params) throws Exception {
    return posMapper.selectLoyaltyRewardPointDetails(params);
  }

  @Override
  public EgovMap selectLoyaltyRewardPointByMemCode(Map<String, Object> params) throws Exception {
    return posMapper.selectLoyaltyRewardPointByMemCode(params);
  }

  @Override
  public void insertUploadedLoyaltyRewardList(Map<String, Object> params) {

    List<PosLoyaltyRewardVO> vos2 = (List<PosLoyaltyRewardVO>) params.get("voList");

    int id = posMapper.getSeqSAL0286M();
    params.put("id", id);

    posMapper.insertUploadedLoyaltyRewardMaster(params);

    List<Map> list = vos2.stream().map(r -> {
        final int seq  = posMapper.getSeqSAL0287D();

        Map<String, Object> map = BeanConverter.toMap(r);
        map.put("id", id);
        map.put("itmId", seq);
        map.put("memCode", r.getMemCode());
        map.put("balanceCapped", r.getBalanceCapped());
        map.put("discount", r.getDiscount());
        map.put("startDate", r.getStartDate());
        map.put("endDate", r.getEndDate());
        map.put("stus", params.get("stus"));
        map.put("userId", params.get("usrId"));
        return map;
    }).collect(Collectors.toList());

    Map<String, Object> bulkMap = new HashMap<>();

    int size = 10000;
    int page = list.size() / size;
    int start;
    int end;

    for (int i = 0; i <= page; i++) {
      start = i * size;
      end = size;

      if (i == page) {
        end = list.size();
      }
      if(list.stream().skip(start).limit(end).count() != 0){
          bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
          posMapper.insertLoyaltyRewardPointItmBulk(bulkMap);
      }
    }

    posMapper.SP_POS_LRP_CONFIRM(params);


  }

}
