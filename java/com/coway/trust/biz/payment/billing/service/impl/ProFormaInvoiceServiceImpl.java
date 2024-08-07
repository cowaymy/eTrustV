package com.coway.trust.biz.payment.billing.service.impl;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.payment.billing.service.ProFormaInvoiceService;
import com.coway.trust.biz.sales.order.vo.DiscountEntryVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderSchemeConversionVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.text.DecimalFormat;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("proFormaInvoiceService")
public class ProFormaInvoiceServiceImpl extends EgovAbstractServiceImpl implements ProFormaInvoiceService {

	private static final Logger logger = LoggerFactory.getLogger(ProFormaInvoiceServiceImpl.class);

	@Resource(name = "proFormaInvoiceMapper")
	private ProFormaInvoiceMapper proFormaInvoiceMapper;

	@Override
	public List<EgovMap> searchProFormaInvoiceList(Map<String, Object> params) {
		return proFormaInvoiceMapper.searchProFormaInvoiceList(params);
	}

	@Override
	public List<EgovMap> chkCustType(Map<String, Object> params) {
		return proFormaInvoiceMapper.chkCustType(params);
	}

	@Override
	  public String saveNewProForma(List<Object> pfList, SessionVO sessionVO) {
		 logger.debug("================saveNewProForma - START ================");
	     Map<String, Object> pfMap = new HashMap<String, Object>();
	     String pfNo = proFormaInvoiceMapper.selectDocNo(DocTypeConstants.PROFORMA_NO); //doc no 188
		 pfMap.put("pfNo",pfNo); //REF_NO
		 int pfGroupID = proFormaInvoiceMapper.selectPFGroupID(); //doc no 188
		 pfMap.put("pfGroupID",pfGroupID); //REF_NO

		 //PAY0334D_PRO_FORMA_GRP_ID_SEQ

	     if(pfList.size() > 0){
	    	 Map<String, Object> pf = null;

	    		for (int i=0; i< pfList.size() ; i++) {
	    			pf = (HashMap) pfList.get(i);
	    			logger.debug("================saveNewProForma - PF ================");
	    			 logger.debug(pfList.toString());

	    			pfMap.put("salesOrdId", String.valueOf(pf.get("salesOrdId")));
	    			pfMap.put("packType",pf.get("packType"));
	    			pfMap.put("memCode",pf.get("memCode"));
	    			pfMap.put("adStartDt",pf.get("adStartDt"));
	    			pfMap.put("adEndDt",pf.get("adEndDt"));
	    			pfMap.put("totalAmt",pf.get("totalAmt"));
	    			pfMap.put("packPrice",pf.get("packPrice"));
	    			pfMap.put("remark",pf.get("remark"));
	    			pfMap.put("discount",pf.get("discount"));
	    			pfMap.put("stus","1"); //new pro forma = Active
	    			pfMap.put("creator", sessionVO.getUserId());

	    			proFormaInvoiceMapper.saveNewProForma(pfMap);
	    		}
	     }

		 logger.debug("================saveNewProForma - END ================");
		 logger.debug(pfMap.toString());
	     logger.debug("================saveNewProForma - END ================");

	     return pfNo;
	  }

	@Override
	public List<EgovMap> chkProForma(Map<String, Object> params) {
		return proFormaInvoiceMapper.chkProForma(params);
	}

	@Override
	public List<EgovMap> selectInvoiceBillGroupListProForma(Map<String, Object> params) {
		return proFormaInvoiceMapper.selectInvoiceBillGroupListProForma(params);
	}

	@Override
	public List<EgovMap> getDiscPeriod(Map<String, Object> params) {
		return proFormaInvoiceMapper.getDiscPeriod(params);
	}

	@Transactional
	public int createTaxesBills(Map<String, Object> params, List<Object> taskBillList, SessionVO sessionVO) {

		int userId = sessionVO.getUserId();
    	Map<String, Object> taskOrderMap = new HashMap<String, Object>();
    	String discountTypeId = "7156" ; //Proforma auto convert (SYS0013M)
		int mthRentAmt = Integer.parseInt(params.get("hidMthRentAmt").toString());
    	int value= -1;

    	if(taskBillList.size() > 0){

    		Map<String, Object> hm = null;

    		for (int i=0; i< taskBillList.size() ; i++) {
    			int newTaskId = proFormaInvoiceMapper.getTaskIdSeq();
    	    	int installment = Integer.parseInt(CommonUtils.nvl(params.get("hidDiscStart")).toString());
    	    	int taskCount = 0;
    	    	double taskTotalAmount = 0;
    	    	double discountAmt = 0;

    			hm = (HashMap) taskBillList.get(i);

    	    	logger.debug("map111================" + params.toString());
    	    	logger.debug("discount truefalse === " + !CommonUtils.nvl(params.get("hidDisc").toString()).equals("0"));
       		 	//Insert Discount Management
    	    	if(!CommonUtils.nvl(params.get("hidDisc").toString()).equals("0")){
    	    		logger.debug("in insert");
    	    		if(CommonUtils.nvl(params.get("hidDiscPeriod").toString()).equals("12")){ //1 year advance
   					 discountAmt = mthRentAmt * 0.05;
   				 }else{ //2 year advance
   					 discountAmt = mthRentAmt * 0.10;
   				 }

    	    		logger.debug("discountAmt === " + discountAmt);
   				 //Param for insert discount
   		    	 params.put("ordId", Integer.parseInt(hm.get("salesOrdId").toString()));
   		    	 params.put("discountType", discountTypeId);
   		    	 params.put("discountAmount", discountAmt);
   		    	 params.put("remarks", "Proforma auto convert");
   				 params.put("userId", sessionVO.getUserId());
   				 params.put("dcStatusId", SalesConstants.STATUS_ACTIVE);
   				 params.put("contractId", 0);

   		    	 proFormaInvoiceMapper.insertDiscountEntry(params);
    	    	}

		    	 //Convert Bill to Complete
    			int discPeriod = Integer.parseInt(CommonUtils.nvl(hm.get("discPeriod")).toString());

    			taskTotalAmount = taskTotalAmount + Double.parseDouble(String.valueOf(params.get("hidMthRentAmt")));

    			taskOrderMap.put("salesOrdId", Integer.parseInt(hm.get("salesOrdId").toString()));
    			taskOrderMap.put("taskReferenceNo", "");
                taskOrderMap.put("taskBillTypeId", 159);

                double billAmt;
                billAmt = mthRentAmt - discountAmt;

                taskOrderMap.put("taskBillUpdateBy", userId);
                taskOrderMap.put("taskBillAmt", new DecimalFormat("0.00").format(billAmt));

                taskOrderMap.put("taskBillBatchNo", 0);
                taskOrderMap.put("taskBillGroupId", 0);
                taskOrderMap.put("taskBillRemark", "ProForma Auto Convert" );
                taskOrderMap.put("taskBillUpdateBy", userId);
                taskOrderMap.put("taskBillZRLocationId", 0);
                taskOrderMap.put("taskBillReliefCertificateId", 0);
                taskOrderMap.put("taskBillRentalReliefId", 0);
                taskOrderMap.put("taskBillCnrctId", 0);

                EgovMap  selectSalesOrderMs = proFormaInvoiceMapper.selectSalesOrderMs(hm);
				String custBillId = selectSalesOrderMs.get("custBillId") != null ? String.valueOf(selectSalesOrderMs.get("custBillId")) : "0";
				taskOrderMap.put("newTaskId", newTaskId);
				taskOrderMap.put("taskBillGroupId", custBillId);

				for (int j = 0; j < discPeriod + 1; j++) { //discPeriod 12 = 1 year advance, discPeriod 24 = 2 year advance

					taskCount = taskCount + 1;
                	taskOrderMap.put("taskBillInstNo", installment);
                	installment = installment + 1 ;
           		 	logger.debug("TaskOrderMap111================" + taskOrderMap.toString());

                	proFormaInvoiceMapper.insTaskLogOrder(taskOrderMap);
                }

				Map<String, Object> taskLogMap = new HashMap<String, Object>();
	        	Calendar calendar = Calendar.getInstance();
	        	taskLogMap.put("taskType", "ADV BILL");
	        	taskLogMap.put("billingYear", calendar.get(Calendar.YEAR));
	        	taskLogMap.put("billingMonth", calendar.get(Calendar.MONTH)+1);
	        	taskLogMap.put("taskTotalAmount", taskTotalAmount);
	        	taskLogMap.put("taskCount", taskCount);
	        	taskLogMap.put("status", "SUCCESS");
	        	taskLogMap.put("isConfirmed", 0);
	        	taskLogMap.put("isInvoiceGenerate", 0);
	        	taskLogMap.put("createdBy", userId);
	        	taskLogMap.put("updatedBy", userId);
	        	taskLogMap.put("taskBillRemark", "ProForma Auto Convert");
	        	taskLogMap.put("newTaskId", newTaskId);
	    		logger.debug("taskLogMap111================" + taskLogMap.toString());

	        	proFormaInvoiceMapper.insBillTaskLog(taskLogMap);

	    		//logger.debug("newTaskId111================" + newTaskId);

	        	if(newTaskId > 0){
	        		Map<String, Object> confMap = new HashMap<String, Object>();
	    			confMap.put("taskId", newTaskId);
	    			confMap.put("userId", userId);
	    			proFormaInvoiceMapper.confirmTaxesAdvanceBill(confMap);
	        		value=Integer.parseInt(String.valueOf(confMap.get("p1")));
	        		logger.debug("newTaskId111================" + value);
	        	}
    		}
    	}

		return value;
	}


	@Override
	  public Map<String, Object> updateProForma(Map<String, Object> params, SessionVO sessionVO) {
	    Map<String, Object> resultValue = new HashMap<String, Object>();

		 logger.debug("================farCheckConvertFn - START ================");
		 logger.debug(params.toString());

		 params.put("updator", sessionVO.getUserId());

		 try{
			 proFormaInvoiceMapper.farCheckConvertFn(params);
		 }catch(Exception e){
			 resultValue.put("value", 0);
		 }

	     EgovMap stusMap = new EgovMap();
	     stusMap = proFormaInvoiceMapper.getStatus(params);
	     resultValue.put("stusDesc", stusMap.get("stusDesc"));

		 logger.debug("================farCheckConvertFn - END ================");
		 return resultValue;
	  }

	@Override
	public  EgovMap chkEligible(Map<String, Object> params) {

		EgovMap result = proFormaInvoiceMapper.chkEligible(params);

		if(result == null){
			result = new EgovMap();
		}

		return result;
	}

}
