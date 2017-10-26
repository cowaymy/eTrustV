package com.coway.trust.biz.sales.pos.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("posService")
public class PosServiceImpl extends EgovAbstractServiceImpl implements PosService {

	private static final Logger LOGGER = LoggerFactory.getLogger(PosServiceImpl.class);
	
	@Resource(name = "posMapper")
	private PosMapper posMapper;

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
	public List<EgovMap> selectPSMItmTypeList(Map<String, Object> params) throws Exception {
		
		return posMapper.selectPSMItmTypeList(params);
	}

	@Override
	public List<EgovMap> selectPIItmTypeList() throws Exception {
		
		return posMapper.selectPIItmTypeList();
	}

	@Override
	public List<EgovMap> selectPIItmList(Map<String, Object> params) throws Exception {
		
		return posMapper.selectPIItmList(params);
	}

	@Override
	public List<EgovMap> selectPSMItmList(Map<String, Object> params) throws Exception {
		
		return posMapper.selectPSMItmList(params);
	}

	@Override
	public List<EgovMap> chkStockList(Map<String, Object> params) throws Exception {
		
		List<EgovMap> retunList = null;
		
		retunList = posMapper.chkStockList(params);
		
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
		
		return posMapper.getFilterSerialNum(params);
	}

	@Override
	public List<EgovMap> getConfirmFilterListAjax(Map<String, Object> params) throws Exception {
		
		return posMapper.getFilterSerialNum(params);
	}

	@Override
	@Transactional
	public Map<String, Object> insertPos(Map<String, Object> params) throws Exception {
		
		String docNoPsn = ""; //returnValue
		String docNoInvoice = "";
		LOGGER.info("############### get Params  ################");
		/*  ############### get Params  ################*/
		//Form
		Map<String, Object> posMap = (Map<String, Object>)params.get("form");
		//Grid1
		List<Object> basketGrid = (List<Object>)params.get("prch");
		//Grid2
		List<Object> serialGrid = (List<Object>)params.get("serial");
		
		LOGGER.info("############### get DOC Number & Sequence & full Name & Amounts  ################");
		/*############## get DOC Number & Sequence & full Name & Amounts ###########*/
		params.put("docNoId", SalesConstants.POS_DOC_NO_PSN_NO);
		docNoPsn = posMapper.getDocNo(params); ////////////////////////      PSN (144)
		params.put("docNoId", SalesConstants.POS_DOC_NO_INVOICE_NO);
		docNoInvoice = posMapper.getDocNo(params); ////////////////////   INVOICE (143)
		
		LOGGER.info("################################## docNoPsn : " + docNoPsn);
		LOGGER.info("################################## docNoInvoice : " + docNoInvoice);
		
		EgovMap nameMAp = null;
		nameMAp = posMapper.getUserFullName(posMap);
		
		//Total Amt, Charges , Taxes
		double tempAmt = 0;
		double tempTaxes = 0;
		double tempCharges = 0;
		for (int i = 0; i < basketGrid.size(); i++) {
			Map<String, Object> amtMap  = null;
			amtMap = (Map<String, Object>)basketGrid.get(i);
			
			tempAmt += Double.parseDouble(String.valueOf(amtMap.get("totalAmt")));
			tempTaxes += Double.parseDouble(String.valueOf(amtMap.get("subChng"))); 
			tempCharges += Double.parseDouble(String.valueOf(amtMap.get("subTotal"))); 
		}
		LOGGER.info("############### Parameter Setting , Insert and Update  ################");
		/* #### Parameter Setting , Insert and Update ######*/
		
		//1. ********************************************************************************************************* POS MASTER
		//Seq
		int posMasterSeq = posMapper.getSeqSal0057D(); //master Sequence
		
		//DRAccId , CRAccId Setting
		if(String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)){ //1352   //filter with payment
			
			posMap.put("drAccId", SalesConstants.POS_DRACC_ID_FILTER);  // 540  //122111
			posMap.put("crAccId", SalesConstants.POS_CRACC_ID_FILTER);  // 541  //414002
		}
		if(String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK)){ //1353   //itembank with payment
			
			posMap.put("drAccId", SalesConstants.POS_DRACC_ID_ITEMBANK); //540  //122111
			posMap.put("crAccId", SalesConstants.POS_CRACC_ID_ITEMBANK); //549  //601510
		}
		if(String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME) ||
				String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK_HQ)){  //1357 or 1358
			
			EgovMap accCodeMap = null;
			accCodeMap = posMapper.getItemBankAccCodeByItemTypeID(posMap);
			posMap.put("drAccId", accCodeMap.get("drAccId"));
			posMap.put("crAccId", accCodeMap.get("crAccId"));
			
		}
		
		posMap.put("posMasterSeq", posMasterSeq); //posId = 0   -- 시퀀스 
		posMap.put("docNoPsn", docNoPsn); //posNo = 0  --문서채번
		posMap.put("posBillId", SalesConstants.POS_BILL_ID); //pos Bill Id // 0
		posMap.put("posCustName", nameMAp.get("name")); //posCustName = other Income만 사용함 .. 그러면 나머지는??
		posMap.put("posTotalAmt", tempAmt);
		posMap.put("posCharge", tempCharges); 
		posMap.put("posTaxes", tempTaxes);
		posMap.put("posDiscount", 0);    //TODO 확인 필요
		//hidLocId  와 branch ID
		posMap.put("posMtchId", 0);
		posMap.put("posCustomerId", SalesConstants.POS_CUST_ID);
		posMap.put("userId", params.get("userId"));
		posMap.put("userDeptId", params.get("userDeptId"));
		posMap.put("posStusId", 1); //STUS_ID  ==Active
		posMap.put("userId", params.get("userId"));
		
		if(posMap.get("posReason") == null || String.valueOf(posMap.get("posReason")).equals("")){
			posMap.put("posReason", "0");
		}
		
		//Pos Master Insert
		LOGGER.info("############### 1. POS MASTER INSERT START  ################");
		LOGGER.info("############### 1. POS MASTER INSERT param : " + posMap.toString());
		posMapper.insertPosMaster(posMap);
		LOGGER.info("############### 1. POS MASTER INSERT END  ################");
      //2. ********************************************************************************************************* POS DETAIL
        
        // Grid to Map Params
		// 1). POST TYPE : POS_SALES  
		if((SalesConstants.POS_SALES_MODULE_TYPE_POS_SALES).equals(String.valueOf(posMap.get("insPosModuleType")))){ //2390
                for (int idx = 0; idx < basketGrid.size(); idx++) {  //basket Grid
                	Map<String, Object> itemMap = 	(Map<String, Object>)basketGrid.get(idx);
                	
                	int posDetailSeq = posMapper.getSeqSal0058D(); //detail Sequence
                	itemMap.put("posDetailSeq", posDetailSeq);
                	itemMap.put("posMasterSeq", posMasterSeq);
                	itemMap.put("posItemTaxCodeId", SalesConstants.POS_ITM_TAX_CODE_ID); //32
                	itemMap.put("posMemId", posMap.get("salesmanPopId")); //MEM_ID
                	itemMap.put("posRcvStusId", SalesConstants.POS_DETAIL_NON_RECEIVE); //RCV_STUS_ID  96 == nonReceive
                	itemMap.put("userId", params.get("userId"));
                	LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT START  ################");
            		LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT param : " + itemMap.toString());
                	posMapper.insertPosDetail(itemMap);
                	LOGGER.info("############### 2 - " + idx + "  POS DETAIL INSERT END  ################");
                	
                	//FILTER 유무 확인 
                	if((SalesConstants.POS_STOCK_TYPE_FILTER).equals(String.valueOf(itemMap.get("stkTypeId")))){  //62 Filter
                		
                		if(serialGrid != null){
                			for (int i = 0; i < serialGrid.size(); i++) {
                				Map<String, Object> serialMap = (Map<String, Object>)serialGrid.get(idx);
                				int serialSeq =  posMapper.getSeqSal0147M();
                				
                				serialMap.put("serialSeq", serialSeq);
                				serialMap.put("posMasterSeq", posMasterSeq);
                				serialMap.put("userId", params.get("userId"));
                				//TODO ITEM Status ID? 
                				//serialMap.put("posItmStusId", 1);  
                				
                				LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT START  ################");
                				LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT param : " + serialMap.toString());
                				posMapper.insertSerialNo(serialMap);
                				LOGGER.info("############### 2 - Serial - " + i + "  POS SERIAL INSERT END  ################");
                				
            				}
                		}
                	}//Filter insert End
        		}//Detail Insert End
		}
        // 2). POST TYPE : DEDUCTION COMMISSION  //2391
		/*if((SalesConstants.POS_SALES_MODULE_TYPE_DEDUCTION_COMMISSION).equals(String.valueOf(posMap.get("insPosModuleType")))){ //2391
			for (int idx = 0; idx < basketGrid.size(); idx++) {  //basket Grid
				
				Map<String, Object> deducItemMap = 	(Map<String, Object>)basketGrid.get(idx); //item List
				
				for (int i = 0; i < memberGrid.size(); i++) {
					Map<String, Object> memMap = 	(Map<String, Object>)memberGrid.get(idx); //item List
					int posDetailDuducSeq = posMapper.getSeqSal0058D(); //detail Sequence
					memMap.put("posDetailDuducSeq", posDetailDuducSeq);
					memMap.put("posMasterSeq", posMasterSeq);
					memMap.put("posDetailStkId", deducItemMap.get("stkCode"));  //POS_ITM_STOCK_ID
					memMap.put("posDetailQty", deducItemMap.get("qty"));  //POS_ITM_QTY
					memMap.put("posDetailUnitPrc", deducItemMap.get("amt")); //Price
					memMap.put("posDetailTotal", deducItemMap.get("totalAmt")); //ToTal
					memMap.put("posDetailCharge", deducItemMap.get("subTotal")); //Charge 
					memMap.put("posDetailTaxs", deducItemMap.get("subChng")); //Tax 
					
					memMap.put("posItemTaxCodeId", SalesConstants.POS_ITM_TAX_CODE_ID); //32
					memMap.put("posMemId", "그리드에서 가져오기"); //MEM_ID
					memMap.put("posMemCode", "그리드에서 가져오기"); //MEM_CODE
					memMap.put("posMemType", "그리드에서 가져오기"); //MEM_TYPE 
					memMap.put("posMemName", "그리드에서 가져오기");//NAME
					memMap.put("posMemFullName", "그리드에서 가져오기");//FULL_NAME
					memMap.put("posMemNric", "그리드에서 가져오기");//NRIC
					memMap.put("posMemStusId", "그리드에서 가져오기");//MEM_STUS_ID
					memMap.put("posRcvStusId", SalesConstants.POS_DETAIL_NON_RECEIVE); //RCV_STUS_ID  96 == nonReceive
					memMap.put("userId", params.get("userId"));
				}
				
			}
		}*/
        
        //3.  ********************************************************************************************************* ACC BILLING
      		Map<String, Object> accBillingMap = new HashMap<String, Object>();
      		int posBillSeq = posMapper.getSeqPay0007D();
      		accBillingMap.put("posBillSeq", posBillSeq);  // accbilling.BillID = 0;
      		accBillingMap.put("posBillTypeId", SalesConstants.POS_BILL_TYPE_ID); //accbilling.BillTypeID = 569;
      		accBillingMap.put("posBillSoId", 0); //   accbilling.BillSOID = 0;
      		accBillingMap.put("posBillMemId", 0); // accbilling.BillMemID = 0;
      		accBillingMap.put("posBillAsId", 0);  //accbilling.BillASID = 0;
      		accBillingMap.put("posBillPayTypeId", 0);  //accbilling.BillPayTypeID = 0;
      		accBillingMap.put("docNoPsn", docNoPsn); // accbilling.BillNo = ""; //update later //POS RefNo.
      		accBillingMap.put("posMemberShipNo", ""); //accbilling.BillMemberShipNo = "";
      		accBillingMap.put("posBillAmt", tempAmt); // accbilling.BillAmt = Convert.ToDouble(totalcharges);
      		accBillingMap.put("posBillRem", posMap.get("posRemark")); //accbilling.BillRemark = this.txtRemark.Text.Trim();
      		accBillingMap.put("posBillIsPaid", 1); //accbilling.BillIsPaid = true;
      		accBillingMap.put("posBillIsComm", 0); // accbilling.BillIsComm = false;
      		accBillingMap.put("userId", params.get("userId"));
      		accBillingMap.put("posSyncChk", 1); //accbilling.SyncCheck = true;
      		accBillingMap.put("posCourseId", 0); //accbilling.CourseID = 0;
      		accBillingMap.put("posStatusId", 1);// accbilling.StatusID = 1;
      		LOGGER.info("############### 3. POS ACC BILLING INSERT START  ################");
    		LOGGER.info("############### 3. POS ACC BILLING INSERT param : " + accBillingMap.toString());
      		posMapper.insertPosBilling(accBillingMap);
      		LOGGER.info("############### 3. POS ACC BILLING INSERT END  ################");
      		
      	//4.  ********************************************************************************************************* POS MASTER UPDATE BILL_ID
      		Map<String, Object> posUpMap = new HashMap<String, Object>();
      		posUpMap.put("posBillSeq", posBillSeq);
      		posUpMap.put("posMasterSeq", posMasterSeq);
      		LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE START  ################");
    		LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE param : " + posUpMap.toString());
      		posMapper.updatePosMasterPosBillId(posUpMap);
      		LOGGER.info("############### 4. POS MASTER  BILL_ID UPDATE END  ################");
      		
      	//5.  ********************************************************************************************************* ACC ORDER BILL

    		//3. ACCORDERBILLING
    		Map<String, Object> accOrdBillingMap = new HashMap<String, Object>();
    		int accOrderBillSeq = posMapper.getSeqPay0016D();
    		
    		accOrdBillingMap.put("posOrderBillSeq", accOrderBillSeq); //accorderbill.AccBillID = 0;
    		accOrdBillingMap.put("posOrdBillTaskId", 0);  // accorderbill.AccBillTaskID = 0;
    		accOrdBillingMap.put("posOrdBillRefNo",  "1000"); //accorderbill.AccBillRefNo = "1000"; //update later //at db
    		accOrdBillingMap.put("posOrdBillOrdId", 0); //accorderbill.AccBillOrderID = 0;
    		accOrdBillingMap.put("posOrdBillOrdNo", ""); //accorderbill.AccBillOrderNo = "";
    		accOrdBillingMap.put("posOrdBillTypeId", SalesConstants.POS_ORD_BILL_TYPE_ID); //accorderbill.AccBillTypeID = 1159; //System Generate Bill
    		accOrdBillingMap.put("posOrdBillModeId", SalesConstants.POS_ORD_BILL_MODE_ID); //accorderbill.AccBillModeID = 1351; //SOI Bill (POS New Version)
    		accOrdBillingMap.put("posOrdBillScheduleId", 0); // accorderbill.AccBillScheduleID = 0;
    		accOrdBillingMap.put("posOrdBillSchedulePeriod", 0); //accorderbill.AccBillSchedulePeriod = 0;
    		accOrdBillingMap.put("posOrdBillAdjustmentId", 0); //accorderbill.AccBillAdjustmentID = 0;
    		accOrdBillingMap.put("posOrdBillScheduleAmt", tempAmt); //accorderbill.AccBillScheduleAmount = decimal.Parse(totalcharges);
    		accOrdBillingMap.put("posOrdBillAdjustmentAmt", 0); //accorderbill.AccBillAdjustmentAmount = 0;
    		accOrdBillingMap.put("posOrdBillTaxesAmt", tempTaxes); //accorderbill.AccBillTaxesAmount = Convert.ToDecimal(string.Format("{0:0.00}", decimal.Parse(totalcharges) - (System.Convert.ToDecimal(totalcharges) * 100 / 106)));
    		accOrdBillingMap.put("posOrdBillNetAmount", tempAmt); // accorderbill.AccBillNetAmount = decimal.Parse(totalcharges);
    		accOrdBillingMap.put("posOrdBillStatus", 1); //accorderbill.AccBillStatus = 1;
    		accOrdBillingMap.put("posOrdBillRem", docNoInvoice); //accorderbill.AccBillRemark = ""; //Invoice No.
    		accOrdBillingMap.put("userId", params.get("userId"));
    		accOrdBillingMap.put("posOrdBillGroupId", 0); //accorderbill.AccBillGroupID = 0;
    		accOrdBillingMap.put("posOrdBillTaxCodeId", SalesConstants.POS_ORD_BILL_TAX_CODE_ID); //accorderbill.AccBillTaxCodeID = 32;
    		accOrdBillingMap.put("posOrdBillTaxRate", SalesConstants.POS_ORD_BILL_TAX_RATE); //accorderbill.AccBillTaxRate = 6;  
    		accOrdBillingMap.put("posOrdBillAcctCnvr", 0); //TODO ASIS 소스 없음
    		accOrdBillingMap.put("posOrdBillCntrctId", 0); //TODO ASIS 소스 없음
    		
    		LOGGER.info("############### 5. POS ACC ORDER BILL INSERT START  ################");
    		LOGGER.info("############### 5. POS ACC ORDER BILL INSERT param : " + accOrdBillingMap.toString());
    		posMapper.insertPosOrderBilling(accOrdBillingMap);
    		LOGGER.info("############### 5. POS ACC ORDER BILL INSERT END  ################");
    		
    	//6.  ********************************************************************************************************* ACC TAX INVOICE MISCELLANEOUS

    		Map<String, Object> accTaxInvoiceMiscellaneouMap = new HashMap<String, Object>();
    		int accTaxInvMiscSeq = posMapper.getSeqPay0031D();
    		
    		accTaxInvoiceMiscellaneouMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq); //InvMiscMaster.TaxInvoiceID = 0;
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvRefNo", docNoInvoice); //InvMiscMaster.TaxInvoiceRefNo = ""; //update later
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvSvcNo", docNoPsn); //InvMiscMaster.TaxInvoiceServiceNo = ""; //SOI No.
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvType", SalesConstants.POS_TAX_INVOICE_TYPE); //  InvMiscMaster.TaxInvoiceType = 142; //pos new version 
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvCustName", nameMAp.get("name")); //   InvMiscMaster.TaxInvoiceCustName = this.txtCustName.Text.Trim();
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvCntcPerson", nameMAp.get("name")); // InvMiscMaster.TaxInvoiceContactPerson = this.txtCustName.Text.Trim();
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvTaskId", 0); //InvMiscMaster.TaxInvoiceTaskID = 0;
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvUserName", params.get("userName")); // InvMiscMaster.TaxInvoiceRemark = li.LoginID;
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvCharges", tempCharges); //  InvMiscMaster.TaxInvoiceCharges = Convert.ToDecimal(string.Format("{0:0.00}", (decimal.Parse(totalcharges) * 100 / 106)));
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvTaxes", tempTaxes); //InvMiscMaster.TaxInvoiceTaxes = Convert.ToDecimal(string.Format("{0:0.00}", decimal.Parse(totalcharges) - (decimal.Parse(totalcharges) * 100 / 106)));
    		accTaxInvoiceMiscellaneouMap.put("posTaxInvTotalCharges", tempAmt); //InvMiscMaster.TaxInvoiceAmountDue = decimal.Parse(totalcharges);
    		accTaxInvoiceMiscellaneouMap.put("userId", params.get("userId"));
    		
    		//TODO 추후 삭제
    		/* Magic Address 미구현 추후 삭제*/
    		accTaxInvoiceMiscellaneouMap.put("addr1", "");
    		accTaxInvoiceMiscellaneouMap.put("addr2", "");
    		accTaxInvoiceMiscellaneouMap.put("addr3", "");
    		accTaxInvoiceMiscellaneouMap.put("addr4", "");
    		accTaxInvoiceMiscellaneouMap.put("postCode", "");
    		accTaxInvoiceMiscellaneouMap.put("stateName", "");
    		accTaxInvoiceMiscellaneouMap.put("cnty", "");
    		
    		LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS INSERT START  ################");
    		LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS INSERT param : " + accTaxInvoiceMiscellaneouMap.toString());
    		posMapper.insertPosTaxInvcMisc(accTaxInvoiceMiscellaneouMap);
    		LOGGER.info("############### 6. POS ACC TAX INVOICE MISCELLANEOUS END  ################");
    	//7.  ********************************************************************************************************* ACC TAX INVOICE MISCELLANEOUS_SUB 
    		int invItemTypeID = 0;
            if (String.valueOf(params.get("insPosType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)){ //filter
            	invItemTypeID = 1355;
            }
            if (String.valueOf(params.get("insPosType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK)){ //item bank
            	invItemTypeID = 1356;
            }
            if (String.valueOf(params.get("insPosType")).equals(SalesConstants.POS_SALES_TYPE_OTHER_INCOME)) { //other income
            	invItemTypeID = 1359;
            }
            if (String.valueOf(params.get("insPosType")).equals(SalesConstants.POS_SALES_TYPE_ITMBANK_HQ)){ //item bank-HQ
            	invItemTypeID = 1360;
            }
            for (int idx = 0; idx < basketGrid.size(); idx++) {
            	Map<String, Object> invDetailMap  = new HashMap<String, Object>();
            	invDetailMap = (Map<String, Object>)basketGrid.get(idx);
            	int invDetailSeq = posMapper.getSeqPay0032D();
            	
            	invDetailMap.put("invDetailSeq", invDetailSeq); //InvMiscD.InvocieItemID = 0;
            	invDetailMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq); //InvMiscD.TaxInvoiceID = 0; //update later
            	invDetailMap.put("invItemTypeID", invItemTypeID); //InvMiscD.InvoiceItemType = invItemTypeID;
            	invDetailMap.put("posTaxInvSubOrdNo", ""); //InvMiscD.InvoiceItemOrderNo = "";
            	invDetailMap.put("posTaxInvSubItmPoNo", ""); //InvMiscD.InvoiceItemPONo = "";
            	// InvMiscD.InvoiceItemCode = itm.GetDataKeyValue("ItemStkCode").ToString();
            	//InvMiscD.InvoiceItemDescription1 = itm.GetDataKeyValue("ItemStkDesc").ToString();
            	invDetailMap.put("posTaxInvSubDescSub", ""); //InvMiscD.InvoiceItemDescription2 = "";
            	invDetailMap.put("posTaxInvSubSerialNo", ""); //InvMiscD.InvoiceItemSerialNo = "";
            	//InvMiscD.InvoiceItemQuantity = int.Parse(itm.GetDataKeyValue("ItemQty").ToString());
            	//InvMiscD.InvoiceItemUnitPrice = decimal.Parse(itm.GetDataKeyValue("ItemUnitPrice").ToString());
            	invDetailMap.put("posTaxInvSubGSTRate", SalesConstants.POS_INV_ITM_GST_RATE);  //InvMiscD.InvoiceItemGSTRate = 6;
            	//InvMiscD.InvoiceItemGSTTaxes = Convert.ToDecimal(string.Format("{0:0.00}", decimal.Parse(itm["ItemTotalAmt"].Text) - (decimal.Parse(itm["ItemTotalAmt"].Text) * 100 / 106)));
            	//InvMiscD.InvoiceItemCharges = Convert.ToDecimal(string.Format("{0:0.00}", (decimal.Parse(itm["ItemTotalAmt"].Text) * 100 / 106)));
            	//InvMiscD.InvoiceItemAmountDue = decimal.Parse(itm.GetDataKeyValue("ItemTotalAmt").ToString());
            	
            	//TODO 추후 삭제
            	/*### Masic Address 미반영  ###*/
            	invDetailMap.put("posTaxInvSubAddr1", ""); //InvMiscD.InvoiceItemAdd1 = "";
            	invDetailMap.put("posTaxInvSubAddr2", ""); //InvMiscD.InvoiceItemAdd2 = "";
            	invDetailMap.put("posTaxInvSubAddr3", ""); //InvMiscD.InvoiceItemAdd3 = "";
            	invDetailMap.put("posTaxInvSubAddr4", ""); ////InvMiscD.InvoiceItemAdd3 = null;
            	invDetailMap.put("posTaxInvSubPostCode", ""); //InvMiscD.InvoiceItemPostCode = "";
            	invDetailMap.put("posTaxInvSubAreaName", ""); // areaName
            	invDetailMap.put("posTaxInvSubStateName", ""); //InvMiscD.InvoiceItemStateName = "";
            	invDetailMap.put("posTaxInvSubCntry", ""); //InvMiscD.InvoiceItemCountry = "";
            	
            	LOGGER.info("############### 7 - "+idx+" POS ACC TAX INVOICE MISCELLANEOUS_SUB  INSERT START  ################");
        		LOGGER.info("############### 7 - "+idx+" POS ACC TAX INVOICE MISCELLANEOUS_SUB  INSERT param : " + invDetailMap.toString());
            	posMapper.insertPosTaxInvcMiscSub(invDetailMap);
            	LOGGER.info("############### 7 - "+idx+" POS ACC TAX INVOICE MISCELLANEOUS END  ################");
			}
            
          //8.  ********************************************************************************************************* InvStkRecordCard --> Only For Filter/Spare Part Type
            
            if(String.valueOf(posMap.get("insPosSystemType")).equals(SalesConstants.POS_SALES_TYPE_FILTER)){  //insPosSystemType == 1352   POS_SALES_TYPE_FILTER  posMap
            	
            	for (int idx = 0; idx < basketGrid.size(); idx++) {
                 	
            		Map<String, Object> recordlMap  = (Map<String, Object>)basketGrid.get(idx);
            		
            		//LOG0014D
            		int stkRecordSeq =  posMapper.getSeqLog0014D();
            		
            		recordlMap.put("stkRecordSeq", stkRecordSeq); //invStkCard.SRCardID = 0;
            		//TODO brnchId 를 넣을건지 , locId 를 넣을 건지 선택해야함 (현재는 BranchId)
            	    // Location ID? Branch ID? == Location Id (now)
            		//invStkCard.StockID = int.Parse(itm.GetDataKeyValue("ItemStkID").ToString());
            		//invStkCard.EntryDate = Convert.ToDateTime(this.dpSalesDate.SelectedDate);
            		recordlMap.put("invStkRecordTypeId", SalesConstants.POS_INV_STK_TYPE_ID); //invStkCard.TypeID = 571;
            		recordlMap.put("invStkRecordRefNo", docNoPsn); //invStkCard.RefNo = ""; //update later //POS No. 144Doc 
            		recordlMap.put("invStkRecordOrdId", 0); //invStkCard.SalesOrderId = 0;
            		recordlMap.put("invStkRecordItmNo", idx); //   invStkCard.ItemNo = count;
            		recordlMap.put("invStkRecordSourceId", SalesConstants.POS_INV_SOURCE_ID); //   invStkCard.SourceID = 477;
            		recordlMap.put("invStkRecordProjectId", 0); //invStkCard.ProjectID = 0;
            		recordlMap.put("invStkRecordBatchNo", 0); //invStkCard.BatchNo = 0;
            		//invStkCard.Qty = -int.Parse(itm.GetDataKeyValue("ItemQty").ToString());
            		recordlMap.put("invStkRecordCurrId", SalesConstants.POS_INV_CURR_ID); //invStkCard.CurrID = 479;
            		recordlMap.put("invStkRecordCurrRate", SalesConstants.POS_INV_CURR_RATE); //invStkCard.CurrRate = 1;
            		recordlMap.put("invStkRecordCost", 0); //invStkCard.Cost = 0;
            		recordlMap.put("invStkRecordPrice", 0); //invStkCard.Price = 0;
            		recordlMap.put("invStkRecordRem", posMap.get("posRemark")); //invStkCard.Remark = !string.IsNullOrEmpty(this.txtRemark.Text.Trim()) ? this.txtRemark.Text.Trim() : "";
            		recordlMap.put("invStkRecordSerialNo", ""); //invStkCard.SerialNo = "";
            		recordlMap.put("invStkRecordInstallNo", ""); //invStkCard.InstallNo = "";
            		//invStkCard.CostDate = DateTime.Now;
            		recordlMap.put("invStkRecordAppTypeId", 0); //invStkCard.AppTypeID = 0;
            		recordlMap.put("invStkRecordStkGrade", ""); //invStkCard.StkGrade = string.Empty;
            		recordlMap.put("invStkRecordInstallFail", 0); //invStkCard.InstallFail = false;
            		recordlMap.put("invStkRecordIsSynch", 0); //invStkCard.IsSynch = false;
            		recordlMap.put("invStkRecordEntryMthId", 0);  //ENTRY_MTH_ID
            		
            		LOGGER.info("############### 8. POS InvStkRecordCard INSERT START  ################");
            		LOGGER.info("############### 8. POS InvStkRecordCard INSERT param : " + recordlMap.toString());
            		posMapper.insertStkRecord(recordlMap);
            		LOGGER.info("############### 8. POS InvStkRecordCard END  ################");
                 	
            	 }
         	}// end 8
            
            LOGGER.info("##################### POS Request Success!!! ######################################");
            LOGGER.info("##################### POS Request Success!!! ######################################");
            LOGGER.info("##################### POS Request Success!!! ######################################");
           //  *********************   PAYMENT LOGIC START *********************   //  
           //9.  ********************************************************************************************************* PAY X  
           //  *********************   PAYMENT LOGIC END *********************   //
            
            
            LOGGER.info("################################## return value(docNoPsn): "  + docNoPsn);
            
            //retrun Map
            Map<String, Object> rtnMap = new HashMap<String, Object>();
            rtnMap.put("reqDocNo", docNoPsn);
		return rtnMap;
	}

	@Override
	public List<EgovMap> getUploadMemList(Map<String, Object> params) throws Exception {
		
		return posMapper.getUploadMemList(params);
	}
}
