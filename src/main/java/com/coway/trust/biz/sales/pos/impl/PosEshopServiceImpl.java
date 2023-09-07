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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.pos.PosEshopService;
import com.coway.trust.biz.sales.pos.PosStockService;
import com.coway.trust.biz.sales.pos.vo.PosDetailVO;
import com.coway.trust.biz.sales.pos.vo.PosGridVO;
import com.coway.trust.biz.sales.pos.vo.PosLoyaltyRewardVO;
import com.coway.trust.biz.sales.pos.vo.PosMasterVO;
import com.coway.trust.biz.sales.pos.vo.PosMemberVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.math.BigDecimal;
import com.uwyn.jhighlight.fastutil.Hash;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("posEshopService")
public class PosEshopServiceImpl extends EgovAbstractServiceImpl implements PosEshopService {

  private static final Logger LOGGER = LoggerFactory.getLogger(PosEshopServiceImpl.class);

  @Resource(name = "posEshopMapper")
  private PosEshopMapper posMapper;

  @Autowired
  private MessageSourceAccessor messageAccessor;


  @Override
  public EgovMap selectItemPrice(Map<String, Object> params) throws Exception {

	return   posMapper.selectItemPrice(params);
  }

	@Override
	@Transactional
	public int insertPosEshopItemList(Map<String, Object> params) throws Exception {

			List<Object> addList = (List<Object>)params.get("add");
			int seq = 0;
			int result = 0;

			if(addList != null && addList.size() > 0){

				for (int idx = 0; idx < addList.size(); idx++) {

					Map<String, Object> insMap = (Map<String, Object>)addList.get(idx);

					Map<String, Object> heardMap = new HashMap<String, Object>();
					heardMap.put("purcItems_addItem", insMap.get("purcItems_addItem"));

					List<EgovMap> itemList = posMapper.checkDuplicatedStock(heardMap);
					if(itemList.size() !=0){
						 throw new Exception("Same item is not allow duplicated to be added.");
					}

			  		heardMap.put("id", posMapper.getSeqSAL0321D());
			  		heardMap.put("posType", insMap.get("posType_addItem"));
			  		heardMap.put("sellingType", insMap.get("sellingType_addItem"));
			  		heardMap.put("itemId", insMap.get("purcItems_addItem"));
			  		heardMap.put("itemCtgryId", insMap.get("category_addItem"));
			  		heardMap.put("itemType", insMap.get("itemType_addItem"));
			  		heardMap.put("itemQty", insMap.get("qtyPerCarton_addItem"));
			  		heardMap.put("itemWeight", insMap.get("unitWeight_addItem"));
			  		heardMap.put("itemPrice", insMap.get("sellingPrice_addItem"));
			  		heardMap.put("itemSize", insMap.get("size_addItem"));
			  		heardMap.put("itemAttachGrpId", insMap.get("attachGrpId_addItem"));
			  		heardMap.put("totalPrice", insMap.get("pricePerCarton_addItem"));
			  		heardMap.put("totalWeight", insMap.get("weightPerCarton_addItem"));
			  		heardMap.put("crtId", params.get("userId"));

			  	   result= posMapper.insertEshopItemList(heardMap);
				}
			}
			return result;
	}


	@Override
	public List<EgovMap> selectItemList(Map<String, Object> params) {
		return posMapper.selectItemList(params);
	}

	@Override
	public List<EgovMap> selectItemList2(Map<String, Object> params) {
		return posMapper.selectItemList2(params);
	}

	@Override
	public int removeEshopItemList(Map<String, Object> params) throws Exception {

	   int result = posMapper.removeEshopItemList(params);

	   return result;
	}


	  @Override
	  public int updatePosEshopItemList(Map<String, Object> params) throws Exception {

	  		Map<String, Object>  heardMap  = null;

	  		LOGGER.debug(" params updatePosEshopItemList===>"+params.toString());

	  		heardMap= new HashMap<String, Object>();

	  		heardMap.put("id", params.get("id_editItem"));
	  		heardMap.put("itemQty", params.get("qtyPerCarton_editItem"));
	  		heardMap.put("itemWeight", params.get("unitWeight_editItem"));
	  		heardMap.put("itemPrice", params.get("sellingPrice_editItem"));
	  		heardMap.put("itemSize", params.get("size_editItem"));
	  		heardMap.put("itemAttachGrpId", params.get("attachGrpId_editItem"));
	  		heardMap.put("totalPrice", params.get("pricePerCarton_editItem"));
	  		heardMap.put("totalWeight", params.get("weightPerCarton_editItem"));
	  		heardMap.put("updId", params.get("userId"));

	  	    int result = posMapper.updateEshopItemList(heardMap);

		    return result;

	  }


	  @Override
	  @Transactional
	  public int insUpdPosEshopShipping(Map<String, Object> params) throws Exception {

			List<Object> addList = (List<Object>)params.get("add");
			List<Object> removeList = (List<Object>)params.get("remove");
			int result = 0;

			LOGGER.debug("removeList insUpdPosEshopShipping===>"+removeList.toString());

			//__________________________________________________________________________________Add
			if(addList != null && addList.size() > 0){

				for (int idx = 0; idx < addList.size(); idx++) {

					Map<String, Object> addMap = (Map<String, Object>)addList.get(idx);

					LOGGER.debug(" addMap insUpdPosEshopShipping===>"+addList.toString());

					//params Set
					Map<String, Object> insMap = new HashMap<String, Object>();

					int seq = 0;
					seq=posMapper.getSeqSAL0322D();

					insMap.put("id", seq);
					insMap.put("regionalType", addMap.get("regionalType"));
					insMap.put("weightFrom", addMap.get("totalWeightFrom"));
					insMap.put("weightTo", addMap.get("totalWeightTo"));
					insMap.put("startDt", addMap.get("startDt"));
					insMap.put("endDt", addMap.get("endDt"));
					insMap.put("shippingFee", addMap.get("totalShippingFee"));
					insMap.put("crtId",  params.get("crtUserId"));

					result = posMapper.insertEshopShippingList(insMap);

				}
			}

			//__________________________________________________________________________________Update
			if(removeList != null && removeList.size() > 0){
				for (int idx = 0; idx < removeList.size(); idx++) {

					Map<String, Object> removeMap = (Map<String, Object>)removeList.get(idx);


					LOGGER.debug("updList insUpdPosEshopShipping===>"+removeList.toString());

					//params Set
					Map<String, Object> delMap = new HashMap<String, Object>();
					delMap.put("id", removeMap.get("id"));

					result = posMapper.removeEshopShippingList(delMap);

				}
			}

			return result;
		}


	  @Override
		public List<EgovMap> selectShippingList(Map<String, Object> params) {
			return posMapper.selectShippingList(params);
		}

	  @Override
	  public int updatePosEshopShipping(Map<String, Object> params) throws Exception {

	  		Map<String, Object>  heardMap  = null;

	  		LOGGER.debug(" params updatePosEshopShipping===>"+params.toString());

	  		heardMap= new HashMap<String, Object>();

	  		heardMap.put("id", params.get("id_editShippingItem"));
	  		heardMap.put("regionalType", params.get("regionalType_editShippingItem"));
	  		heardMap.put("weightFrom", params.get("weightFrom_edit"));
	  		heardMap.put("weightTo", params.get("weightTo_edit"));
	  		heardMap.put("startDt", params.get("startDt_edit"));
	  		heardMap.put("endDt", params.get("endDt_edit"));
	  		heardMap.put("shippingFee", params.get("shippingFee_edit"));
	  		heardMap.put("updId", params.get("userId"));

	  	   int result = posMapper.updatePosEshopShipping(heardMap);

		   return result;

	  }

	  @Override
		public List<EgovMap> selectItemImageList(Map<String, Object> params) {
			return posMapper.selectItemImageList(params);
	  }

	  @Override
		public List<EgovMap> selectCatalogList(Map<String, Object> params) {
			return posMapper.selectCatalogList(params);
	  }

	  @Override
	  public int insertItemToCart(Map<String, Object> params) throws Exception {

	  		Map<String, Object>  heardMap  = null;

	  		heardMap= new HashMap<String, Object>();

	  		int seq = 0;
			seq=posMapper.getSeqSAL0327T();

	  		heardMap.put("grpId", params.get("cartGrpId"));
	  		heardMap.put("id", seq);
	  		heardMap.put("eshopItemId", params.get("cartEshopItemId"));
	  		heardMap.put("itemOrdQty", params.get("orderQty_addToCart"));
	  		heardMap.put("locId", params.get("cartItemLocId"));
	  		heardMap.put("crtId", params.get("userId"));

	  	   int result = posMapper.insertItemToCart(heardMap);

		   return result;

	  }

	  @Override
	  public int getGrpSeqSAL0327T() {
		  return posMapper.getGrpSeqSAL0327T();
	  }

	  @Override
      public List<EgovMap> selectItemCartList(Map<String, Object> params) {
		  return posMapper.selectItemCartList(params);
     }

	  @Override
      public List<EgovMap> selectItemCartList2(Map<String, Object> params) {
		  return posMapper.selectItemCartList2(params);
     }

	  @Override
	  public List<EgovMap> selectDefaultBranchList(Map<String, Object> params) {
		  return posMapper.selectDefaultBranchList(params);
	 }

	 @Override
		public List<EgovMap> selectTotalPrice(Map<String, Object> params) {
			return posMapper.selectTotalPrice(params);
	  }

	 @Override
		public List<EgovMap> selectShippingFee(Map<String, Object> params) {
			return posMapper.selectShippingFee(params);
	  }


	 @Override
		public List<EgovMap> checkAvailableQtyStock(Map<String, Object> params) {
			return posMapper.checkAvailableQtyStock(params);
	  }

	 @Override
	 public Map<String, Object> insertPosEshop(Map<String, Object> params) throws Exception {

		 LOGGER.debug(" insertPosEshop params===>"+params.toString());
	 	int seq = 0;

	 	String sal0325Seq ="";

	 	seq=posMapper.getSeqSAL0325M();
	 	sal0325Seq ="ESN"+CommonUtils.getFillString(Integer.toString(seq), "0",10,"RIGHT");

	 	params.put("esnNo", sal0325Seq);
	 	params.put("grpId", params.get("cartGrpId"));

	    posMapper.insertSAL0325M(params);

		List<EgovMap> itemCartList = posMapper.selectItemCartList2(params);
		LOGGER.debug(" itemCartList===>"+itemCartList.toString());
		if(itemCartList !=null && itemCartList.size()>0){

			for (int i = 0; i < itemCartList.size(); i++) {
				Map<String, Object> addMap = (Map<String, Object>)itemCartList.get(i);

			    addMap.put("esnNo", sal0325Seq);
			    addMap.put("userId", params.get("userId"));
			    addMap.put("itemCode", addMap.get("itemCode"));
			    addMap.put("itemCtgryId", addMap.get("itemCtgryId"));
			    addMap.put("itemOrdQty", addMap.get("itemOrdQty"));
			    addMap.put("itemPrice", addMap.get("itemPrice"));
			    addMap.put("itemWeight", addMap.get("itemWeight"));
			    addMap.put("sellingType", addMap.get("sellingType"));
			    addMap.put("totalOrdPrice", addMap.get("totalOrdPrice"));
			    addMap.put("totalOrdWeight", addMap.get("totalOrdWeight"));
			    addMap.put("itemQty", addMap.get("itemQty"));
			    addMap.put("eshopItemId", addMap.get("eshopItemId"));

				posMapper.insertSAL0326D(addMap);

			}
		}

		posMapper.updateFloatingStockLOG0106M(params);


	 	   // retrun Map
	     Map<String, Object> rtnMap = new HashMap<String, Object>();
	     rtnMap.put("esnNo", sal0325Seq);
	     return rtnMap;

	 }

	 @Override
		public List<EgovMap> checkDiffWarehouse(Map<String, Object> params) {
			return posMapper.checkDiffWarehouse(params);
	  }

	 @Override
		public List<EgovMap> checkDuplicatedStock(Map<String, Object> params) {
			return posMapper.checkDuplicatedStock(params);
	  }


	 @Override
		public List<EgovMap> selectEshopList(Map<String, Object> params) {
			return posMapper.selectEshopList(params);
	  }

	 @Override
		public List<EgovMap> selectPosEshopApprovalList(Map<String, Object> params) {
			return posMapper.selectPosEshopApprovalList(params);
	  }

	 @Override
		public List<EgovMap> selectPosEshopApprovalViewList(Map<String, Object> params) {
			return posMapper.selectPosEshopApprovalViewList(params);
	  }

	 @Override
	  public Map<String, Object> insertPos(Map<String, Object> params) throws Exception {

		   if (params.get("userDeptId") == null ||  "-".equals(params.get("userDeptId"))) {
			  params.put("userDeptId", 0);
		      params.put("userDeptCode", " ");
		    }
		   LOGGER.debug(" insertPos params===>"+params.toString());

		   String docNoPsn = "";
		   String docNoInvoice = "";

		   params.put("docNoId", SalesConstants.POS_DOC_NO_PSN_NO);
		   docNoPsn = posMapper.getDocNo(params); //////////////////////// PSN (144)
		   params.put("docNoId", SalesConstants.POS_DOC_NO_INVOICE_NO);
		   docNoInvoice = posMapper.getDocNo(params); //////////////////// INVOICE

		   Map<String, Object>  heardMap  = new HashMap<String, Object>();
		   Map<String, Object> rtnMap = new HashMap<String, Object>();
		   Map<String, Object> whLocDetail = posMapper.selectWarehouse(params);
		   Map<String, Object> eshopMap = (Map<String, Object>) params.get("form");

	  	   List<EgovMap> approvalList = posMapper.selectPosEshopApprovalViewList(params);
	  	 LOGGER.debug(" insertPosEshop approvalList===>"+approvalList.toString());
	  	  int posMasterSeq = posMapper.getSeqSal0057D(); // master Sequence


		   if(approvalList !=null && approvalList.size()>0){

			  // 1.
			  // *********************************************************************************************************
			  // POS MASTER & POS DETAILS


			   heardMap.put("posMasterSeq", posMasterSeq);
		  	   heardMap.put("docNoPsn", docNoPsn);
		  	   heardMap.put("posBillId", 0);
		  	   heardMap.put("posCustName", String.valueOf(eshopMap.get("contactName")));
		  	   heardMap.put("insPosSystemType", SalesConstants.POS_SALES_TYPE_ITMBANK);
		  	   heardMap.put("insPosModuleType", 6795);
		  	   heardMap.put("posTotalAmt", String.valueOf(eshopMap.get("totalPrice")));
		  	   heardMap.put("posCharge", String.valueOf(eshopMap.get("totalPrice")));
		  	   heardMap.put("posTaxes", 0);
		  	   heardMap.put("posDiscount", 0);
		  	   heardMap.put("hidLocId", String.valueOf(whLocDetail.get("whLocId")));
		  	   heardMap.put("posRemark", "");
		  	   heardMap.put("posMtchId", 0);
		  	   heardMap.put("salesmanPopId", String.valueOf(eshopMap.get("crtId")));
		  	   heardMap.put("posCustomerId",  SalesConstants.POS_CUST_ID);
		  	   heardMap.put("userId", params.get("userId"));
		  	   heardMap.put("userDeptId", params.get("userDeptId"));
		  	   heardMap.put("crAccId", SalesConstants.POS_CRACC_ID_ITEMBANK);
		  	   heardMap.put("drAccId", SalesConstants.POS_DRACC_ID_ITEMBANK);//
		  	   heardMap.put("posReason", "");
		  	   heardMap.put("cmbWhBrnchIdPop", String.valueOf(whLocDetail.get("codeId")));
		  	   heardMap.put("posStusId", SalesConstants.POS_SALES_STATUS_NON_RECEIVE);
		  	   heardMap.put("areaId", null);
		  	   heardMap.put("addrDtl", String.valueOf(eshopMap.get("addrDtl")));
		  	   heardMap.put("streetDtl", String.valueOf(eshopMap.get("streetDtl")));
		  	   heardMap.put("userDeptCode", 0);

		  	   posMapper.insertPosMaster(heardMap);

		  		for (int i = 0; i < approvalList.size(); i++) {
					Map<String, Object> addMap = (Map<String, Object>)approvalList.get(i);

				        int posDetailSeq = posMapper.getSeqSal0058D(); // detail Sequence
				        addMap.put("posDetailSeq", posDetailSeq);
				        addMap.put("posMasterSeq", posMasterSeq);
                        addMap.put("stkId", String.valueOf(addMap.get("itemCode")));
                        addMap.put("inputQty", String.valueOf(addMap.get("itemQty")));
                        addMap.put("amt", String.valueOf(addMap.get("itemPrice")));
                        addMap.put("totalAmt", String.valueOf(addMap.get("totalPrice")));
                        addMap.put("subTotal", String.valueOf(addMap.get("totalPrice")));
                        addMap.put("subChng",0);
				        addMap.put("posItemTaxCodeId", SalesConstants.POS_ITM_TAX_CODE_ID); // 32
				        addMap.put("posMemId", String.valueOf(eshopMap.get("crtId"))); // MEM_ID
				        addMap.put("posRcvStusId", 1); // Active
				        addMap.put("userId", params.get("addMap"));

				        posMapper.insertPosDetail(addMap);
				}

		  	   	Map<String, Object> addMap2 = new HashMap<String, Object>();
		  	   	int posDetailSeq2 = posMapper.getSeqSal0058D(); // detail Sequence

		  	    addMap2.put("posDetailSeq", posDetailSeq2);
		  	    addMap2.put("posMasterSeq", posMasterSeq);
		  	    addMap2.put("stkId", String.valueOf("0"));
		  	    addMap2.put("inputQty", String.valueOf("1"));
		  	    addMap2.put("amt", String.valueOf(eshopMap.get("totalShippingFee")));
		  	    addMap2.put("totalAmt", String.valueOf(eshopMap.get("totalShippingFee")));
		  	    addMap2.put("subTotal", String.valueOf(eshopMap.get("totalShippingFee")));
		  	    addMap2.put("subChng",0);
		  	    addMap2.put("posItemTaxCodeId", SalesConstants.POS_ITM_TAX_CODE_ID); // 32
		  	    addMap2.put("posMemId", String.valueOf(eshopMap.get("crtId"))); // MEM_ID
		  	    addMap2.put("posRcvStusId", 1); // Active
		  	    addMap2.put("userId", params.get("addMap"));

		        posMapper.insertPosDetail(addMap2);

		  		Map<String, Object>  updMap  = new HashMap<String, Object>();
		  		updMap.put("docNoPsn", docNoPsn);
		  		updMap.put("esnNo", params.get("esnNo"));
		  		updMap.put("userId", params.get("userId"));
		  		posMapper.updateEshopPosNo(updMap);

		  	 // *********************************************************************************************************

		  	 // 2.
		     // *********************************************************************************************************
		     // ACC BILLING

		  		Map<String, Object> accBillingMap = new HashMap<String, Object>();

		  	    BigDecimal tempTotalAmt = new BigDecimal("0");
		  	    BigDecimal tempTotalTax = new BigDecimal("0");
		  	    BigDecimal tempTotalCharge = new BigDecimal("0");
		  	    BigDecimal tempTotalDiscount = new BigDecimal("0");

		  	    tempTotalAmt =new BigDecimal((String)  eshopMap.get("totalPrice"));
		  	    tempTotalCharge = tempTotalAmt;

		  	    double rtnAmt = tempTotalAmt.doubleValue();
		  	    double rtnTax = tempTotalTax.doubleValue();
		  	    double rtnCharge = tempTotalCharge.doubleValue();
		  	    double rtnDiscount = tempTotalDiscount.doubleValue();
		  	    rtnAmt = rtnAmt - rtnDiscount;

		  		int posBillSeq = posMapper.getSeqPay0007D();
		  		accBillingMap.put("posBillSeq", posBillSeq); // accbilling.BillID = 0;
		  		accBillingMap.put("posBillTypeId", SalesConstants.POS_BILL_TYPE_ID); // accbilling.BillTypeID
		  		accBillingMap.put("posBillSoId", 0); // accbilling.BillSOID = 0;
		  		accBillingMap.put("posBillMemId", String.valueOf(eshopMap.get("crtId"))); // accbilling.BillMemID
		  		accBillingMap.put("posBillAsId", 0); // accbilling.BillASID = 0;
		  	    accBillingMap.put("posBillPayTypeId", 0); // accbilling.BillPayTypeID = 0;
		  	    accBillingMap.put("docNoPsn", docNoPsn); // accbilling.BillNo = ""; //later update POS RefNo.
		  	    accBillingMap.put("posMemberShipNo", ""); // accbilling.BillMemberShipNo = "";
		  	    accBillingMap.put("posBillAmt", rtnAmt);
		  	    accBillingMap.put("posBillRem", ""); // accbilling.BillRemark
    		  	accBillingMap.put("posBillIsPaid", 1); // accbilling.BillIsPaid = true;
    		    accBillingMap.put("posBillIsComm", 0); // accbilling.BillIsComm = false;
    		    accBillingMap.put("userId", params.get("userId"));
    		    accBillingMap.put("posSyncChk", 1); // accbilling.SyncCheck = true;
    		    accBillingMap.put("posCourseId", 0); // accbilling.CourseID = 0;
    		    accBillingMap.put("posStatusId", 1);// accbilling.StatusID = 1;

    		    posMapper.insertPosBilling(accBillingMap);

		  	// *********************************************************************************************************


    		// 3.
    		// *********************************************************************************************************
    		// POS MASTER UPDATE BILL_ID
    		    Map<String, Object> posUpMap = new HashMap<String, Object>();
    		    posUpMap.put("posBillSeq", posBillSeq);
    		    posUpMap.put("posMasterSeq", posMasterSeq);

    		    posMapper.updatePosMasterPosBillId(posUpMap);


    		// *********************************************************************************************************


    		// 4.
    	    // *********************************************************************************************************
    	    // ACC ORDER BILL

    		    Map<String, Object> accOrdBillingMap = new HashMap<String, Object>();
    		    int accOrderBillSeq = posMapper.getSeqPay0016D();

    		    accOrdBillingMap.put("posOrderBillSeq", accOrderBillSeq); // accorderbill.AccBillID= 0;
    		    accOrdBillingMap.put("posOrdBillTaskId", 0); // accorderbill.AccBillTaskID =0;
    		    accOrdBillingMap.put("posOrdBillRefNo", "1000"); // accorderbill.AccBillRefNo= "1000"; //update later at db
    		    accOrdBillingMap.put("posOrdBillOrdId", 0); // accorderbill.AccBillOrderID = 0;
    		    accOrdBillingMap.put("posOrdBillOrdNo", ""); // accorderbill.AccBillOrderNo = "";
    		    accOrdBillingMap.put("posOrdBillTypeId", SalesConstants.POS_ORD_BILL_TYPE_ID); // accorderbill.AccBillTypeID=1159;SystemGenerate Bill
    		    accOrdBillingMap.put("posOrdBillModeId", SalesConstants.POS_ORD_BILL_MODE_ID); // accorderbill.AccBillMode1351;SOI Bill (POSNewVersion)
    		    accOrdBillingMap.put("posOrdBillScheduleId", 0); // accorderbill.AccBillScheduleID= 0;
    		    accOrdBillingMap.put("posOrdBillSchedulePeriod", 0); // accorderbill.AccBillSchedulePeriod = 0;
    		    accOrdBillingMap.put("posOrdBillAdjustmentId", 0); // accorderbill.AccBillAdjustmentID = 0;
    		    accOrdBillingMap.put("posOrdBillScheduleAmt", rtnAmt); // accorderbill.AccBillScheduleAmount =decimal.Parse(totalcharges);
    		    accOrdBillingMap.put("posOrdBillAdjustmentAmt", 0); // accorderbill.AccBillAdjustmentAmount = 0;
    		    accOrdBillingMap.put("posOrdBillTaxesAmt", rtnTax); // accorderbill.AccBillTaxesAmount=Convert.ToDecimal(string.Format("{0:0.00}",decimal.Parse(totalcharges)-(System.Convert.ToDecimal(totalcharges)* 100 / 106)));
    		    accOrdBillingMap.put("posOrdBillNetAmount", rtnAmt); // accorderbill.AccBillNetAmount =decimal.Parse(totalcharges);
    		    accOrdBillingMap.put("posOrdBillStatus", 1); // accorderbill.AccBillStatus = 1;
    		    accOrdBillingMap.put("posOrdBillRem", docNoInvoice); // accorderbill.AccBillRemark = ""; //Invoice No.
    		    accOrdBillingMap.put("userId", params.get("userId"));
    		    accOrdBillingMap.put("posOrdBillGroupId", 0); // accorderbill.AccBillGroupID = 0;
    		    accOrdBillingMap.put("posOrdBillTaxCodeId", SalesConstants.POS_ORD_BILL_TAX_CODE_ID); // accorderbill.AccBillTaxCodeID= 32;
    		    accOrdBillingMap.put("posOrdBillTaxRate", 0); // accorderbill.AccBillTaxRate = 6;
    		    accOrdBillingMap.put("posOrdBillAcctCnvr", 0); // TODO ASIS 소스 없음
    		    accOrdBillingMap.put("posOrdBillCntrctId", 0); // TODO ASIS 소스 없음

    		    posMapper.insertPosOrderBilling(accOrdBillingMap);


    		 // *********************************************************************************************************


    		// 6.
    		// *********************************************************************************************************
    		// ACC TAX INVOICE MISCELLANEOUS

    		    Map<String, Object> accTaxInvoiceMiscellaneouMap = new HashMap<String, Object>();
    		    int accTaxInvMiscSeq = posMapper.getSeqPay0031D();

    		    accTaxInvoiceMiscellaneouMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq); // InvMiscMaster.TaxInvoiceID = 0;
    		    accTaxInvoiceMiscellaneouMap.put("posTaxInvRefNo", docNoInvoice); // InvMiscMaster.TaxInvoiceRefNo= ""; update later
    		    accTaxInvoiceMiscellaneouMap.put("posTaxInvSvcNo", docNoPsn); // InvMiscMaster.TaxInvoiceServiceNo= ""; //SOI No.
    		    accTaxInvoiceMiscellaneouMap.put("posTaxInvType", SalesConstants.POS_TAX_INVOICE_TYPE); // InvMiscMaster.TaxInvoiceType = 142; pos new version

    		    accTaxInvoiceMiscellaneouMap.put("posTaxInvCustName", String.valueOf(eshopMap.get("contactName"))); // InvMiscMaster.TaxInvoiceCustName= this.txtCustName.Text.Trim();
    		    accTaxInvoiceMiscellaneouMap.put("posTaxInvCntcPerson", String.valueOf(eshopMap.get("contactName")));// InvMiscMaster.TaxInvoiceContactPerson

    		    accTaxInvoiceMiscellaneouMap.put("posTaxInvTaskId", 0); // InvMiscMaster.TaxInvoiceTaskID= 0;
    		    accTaxInvoiceMiscellaneouMap.put("posTaxInvUserName", params.get("userName")); // InvMiscMaster.TaxInvoiceRemark = li.LoginID;
    		    accTaxInvoiceMiscellaneouMap.put("posTaxInvCharges", rtnCharge); // InvMiscMaster.TaxInvoiceCharges =Convert.ToDecimal(string.Format("{0:0.00}", (decimal.Parse(totalcharges) * 100 / 106)));
    		    accTaxInvoiceMiscellaneouMap.put("posTaxInvTaxes", rtnTax); // InvMiscMaster.TaxInvoiceTaxes = Convert.ToDecimal(string.Format("{0:0.00}", decimal.Parse(totalcharges) -(decimal.Parse(totalcharges)* 100 / 106)));
    		    accTaxInvoiceMiscellaneouMap.put("posTaxInvTotalCharges", rtnAmt); // InvMiscMaster.TaxInvoiceAmountDue= decimal.Parse(totalcharges);
    		    accTaxInvoiceMiscellaneouMap.put("userId", params.get("userId"));

    		    posMapper.insertPosTaxInvcMisc(accTaxInvoiceMiscellaneouMap);


    	    // *********************************************************************************************************


    	    // 7.
    		// *********************************************************************************************************
    		// ACC TAX INVOICE MISCELLANEOUS_SUB

    		    int invItemTypeID = 0;
    		    invItemTypeID = 1356;

    		      if(approvalList !=null && approvalList.size()>0){

                  	for (int i = 0; i < approvalList.size(); i++) {
                    		Map<String, Object> invDetailMap = (Map<String, Object>)approvalList.get(i);

              		          int invDetailSeq = posMapper.getSeqPay0032D();
                    	      invDetailMap.put("invDetailSeq", invDetailSeq); // InvMiscD.InvocieItemID  = 0;
                  		      invDetailMap.put("accTaxInvMiscSeq", accTaxInvMiscSeq); // InvMiscD.TaxInvoiceID = 0; //update later
                  		      invDetailMap.put("invItemTypeID", invItemTypeID); // InvMiscD.InvoiceItemType= invItemTypeID;
                  		      invDetailMap.put("posTaxInvSubOrdNo", ""); // InvMiscD.InvoiceItemOrderNo= "";

                  		      invDetailMap.put("posTaxInvSubItmPoNo", ""); // InvMiscD.InvoiceItemPONo = "";
                  		      invDetailMap.put("posTaxInvSubDescSub", ""); // InvMiscD.InvoiceItemDescription2 = "";
                  		      invDetailMap.put("posTaxInvSubSerialNo", ""); // InvMiscD.InvoiceItemSerialNo = "";
                  		      invDetailMap.put("posTaxInvSubGSTRate", 0); // InvMiscD.InvoiceItemGSTRate

                  		      invDetailMap.put("stkCode", String.valueOf(invDetailMap.get("stkCode1")));
                  		      invDetailMap.put("stkDesc", String.valueOf(invDetailMap.get("stkDesc")));
                  		      invDetailMap.put("inputQty", String.valueOf(invDetailMap.get("itemQty")));

                  		      invDetailMap.put("amt", String.valueOf(invDetailMap.get("price")));
                  		      invDetailMap.put("subChng", String.valueOf(invDetailMap.get("totalPrice")));
                  		      invDetailMap.put("totalAmt", String.valueOf(invDetailMap.get("totalPrice")));
                  		      posMapper.insertPosTaxInvcMiscSub(invDetailMap);
                  		}

                  	Map<String, Object> invDetailMap2 = new HashMap<String, Object>();

    		          int invDetailSeq = posMapper.getSeqPay0032D();
    		          invDetailMap2.put("invDetailSeq", invDetailSeq); // InvMiscD.InvocieItemID  = 0;
    		          invDetailMap2.put("accTaxInvMiscSeq", accTaxInvMiscSeq); // InvMiscD.TaxInvoiceID = 0; //update later
    		          invDetailMap2.put("invItemTypeID", invItemTypeID); // InvMiscD.InvoiceItemType= invItemTypeID;
    		          invDetailMap2.put("posTaxInvSubOrdNo", ""); // InvMiscD.InvoiceItemOrderNo= "";

    		          invDetailMap2.put("posTaxInvSubItmPoNo", ""); // InvMiscD.InvoiceItemPONo = "";
    		          invDetailMap2.put("posTaxInvSubDescSub", ""); // InvMiscD.InvoiceItemDescription2 = "";
    		          invDetailMap2.put("posTaxInvSubSerialNo", ""); // InvMiscD.InvoiceItemSerialNo = "";
    		          invDetailMap2.put("posTaxInvSubGSTRate", 0); // InvMiscD.InvoiceItemGSTRate

    		          invDetailMap2.put("stkDesc", "Shipping Fee");
        		      invDetailMap2.put("inputQty", String.valueOf("1"));

        		      invDetailMap2.put("amt", String.valueOf(eshopMap.get("totalShippingFee")));
        		      invDetailMap2.put("subChng", String.valueOf(eshopMap.get("totalShippingFee")));
        		      invDetailMap2.put("totalAmt", String.valueOf(eshopMap.get("totalShippingFee")));
        		      posMapper.insertPosTaxInvcMiscSub(invDetailMap2);

    		      }
    		// *********************************************************************************************************

				rtnMap.put("reqDocNo", docNoPsn);
				rtnMap.put("logError", "000");

		  }
		   else{
			   rtnMap.put("logError", "111");
		   }

		 return rtnMap;
	  }


	 @Override
		public int rejectPos(Map<String, Object> params) {
	        int result = posMapper.rejectPos(params);

	        if (result > 0) {
	        	posMapper.reverseFloatingStockLOG0106M(params);
	        }

			return result;
		}

	 @Override
		public int eshopUpdateCourierSvc(Map<String, Object> params) {

	        int result = posMapper.eshopUpdateCourierSvc(params);

			return result;
		}

	 @Override
		public int completePos(Map<String, Object> params) {
	        int result = posMapper.completePos(params);
			return result;
		}

	 @Override
		public List<EgovMap> selectEshopWhBrnchList(Map<String, Object> params) {
			return posMapper.selectEshopWhBrnchList(params);
	  }

	 @Override
	  @Transactional
	  public int deleteCartItem(Map<String, Object> params) throws Exception {

			List<Object> removeList = (List<Object>)params.get("remove");
			int result = 0;

			LOGGER.debug(" removeList deleteCartItem===>"+removeList.toString());

			//__________________________________________________________________________________Update
			if(removeList != null && removeList.size() > 0){
				for (int idx = 0; idx < removeList.size(); idx++) {

					Map<String, Object> removeMap = (Map<String, Object>)removeList.get(idx);

					//params Set
					Map<String, Object> delMap = new HashMap<String, Object>();
					delMap.put("id", removeMap.get("id"));

					LOGGER.debug(" delMap deleteCartItem===>"+delMap.toString());

					result = posMapper.deleteCartItem(delMap);

				}
			}

			return result;
		}

	 @Override
	  public List<EgovMap> selectEshopWhSOBrnchList() throws Exception {
	    return posMapper.selectEshopWhSOBrnchList();
	  }

	 @Override
	  public List<EgovMap> selectWhSOBrnchItemList() throws Exception {
	    return posMapper.selectWhSOBrnchItemList();
	  }

	 @Override
	  public List<EgovMap> selectEshopStockList(Map<String, Object> params) throws Exception {
	    return posMapper.selectEshopStockList(params);
	  }

	 @Override
	  public List<EgovMap> selectPaymentInfo(Map<String, Object> params){
		 	return posMapper.selectPaymentInfo(params);
	  }

	 @Override
	 public int confirmPayment(Map<String, Object> params) {
			return posMapper.confirmPayment(params);
	 }

	 @Override
	 public void deactivatePaymentAndEsn(Map<String, Object> params) {
			 posMapper.deactivatePaymentAndEsn(params);
	 }

	 @Override
	 public void revertFloatingStockLOG0106M(Map<String, Object> params) {
			 posMapper.revertFloatingStockLOG0106M(params);
	 }

	 @Override
	  public List<EgovMap> checkValidationEsn(Map<String, Object> params){
	    return posMapper.checkValidationEsn(params);
	  }

}
