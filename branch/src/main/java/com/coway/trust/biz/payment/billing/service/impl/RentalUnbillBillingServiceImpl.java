package com.coway.trust.biz.payment.billing.service.impl;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.payment.billing.service.RentalUnbillBillingService;
import com.coway.trust.cmmn.model.SessionVO;
import com.ibm.icu.text.DecimalFormat;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("rentalUnbillBillingService")
public class RentalUnbillBillingServiceImpl extends EgovAbstractServiceImpl implements RentalUnbillBillingService {

	private static final Logger logger = LoggerFactory.getLogger(RentalUnbillBillingServiceImpl.class);

	@Resource(name = "rentalUnbillBillingMapper")
	private RentalUnbillBillingMapper rentalUnbillBillingMapper ;

	/**
	 * selectCustBillOrderNoList 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectCustBillOrderList_U(Map<String, Object> params) {
		return rentalUnbillBillingMapper.selectCustBillOrderList_U(params);
	}
	
	/**
	 * selectRentalBillingSchedule 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectUnbilledRentalBillingSchedule(Map<String, Object> params) {
		return rentalUnbillBillingMapper.selectUnbilledRentalBillingSchedule(params);
	}
	
	/**
	 * createTaxesManualBills (INSERT + CALL PROCEDURE)
	 * @param params
	 * @return
	 */
	@Transactional
	public int createTaxesManualBills(List<Object> formList, List<Object> taskBillList, SessionVO sessionVO) {
		
		int userId = sessionVO.getUserId();
    	int taskCount = 0;
    	double taskTotalAmount = 0;
    	Map<String, Object> taskOrderMap = new HashMap<String, Object>();
    	Map<String, Object> formMap = (Map<String, Object>)formList.get(0);
    	int newTaskId = rentalUnbillBillingMapper.getTaskIdSeq_U();
		
    	if(taskBillList.size() > 0){
    		
    		Map<String, Object> hm = null;
    		
    		for (int i=0; i< taskBillList.size() ; i++) {
    			hm = (HashMap) taskBillList.get(i);
    			
    			taskCount = taskCount + 1;
    			taskTotalAmount = taskTotalAmount + Double.parseDouble(String.valueOf(hm.get("billAmt")));
    			
    			taskOrderMap.put("salesOrdId", String.valueOf(hm.get("salesOrdId")));
    			taskOrderMap.put("taskReferenceNo", "");
    			
                if (String.valueOf(hm.get("billType")).equals("RentalFee")){
                    taskOrderMap.put("taskBillTypeId", "159");
                }else if (String.valueOf(hm.get("billType")).equals("RPF")){
                	taskOrderMap.put("taskBillTypeId", "161");
                }
                
                double billAmt;
                billAmt      =  hm.get("billAmt") != null ? Double.parseDouble(String.valueOf(hm.get("billAmt"))) : 0;
                
                taskOrderMap.put("taskBillUpdateBy", userId);
                taskOrderMap.put("taskBillAmt", new DecimalFormat("0.00").format(billAmt));
                taskOrderMap.put("taskBillInstNo", String.valueOf(hm.get("installment")));
                taskOrderMap.put("taskBillBatchNo", 0);
                taskOrderMap.put("taskBillGroupId", 0);
                taskOrderMap.put("taskBillRemark", String.valueOf(formMap.get("remark")).replace("'","''"));
                taskOrderMap.put("taskBillUpdateBy", userId);
                taskOrderMap.put("taskBillZRLocationId", 0);
                taskOrderMap.put("taskBillReliefCertificateId", 0);
                taskOrderMap.put("taskBillRentalReliefId", 0);
                taskOrderMap.put("taskBillCnrctId", 0);
                
                EgovMap  selectSalesOrderMs_U = rentalUnbillBillingMapper.selectSalesOrderMs_U(hm);
				String custBillId = selectSalesOrderMs_U.get("custBillId") != null ? String.valueOf(selectSalesOrderMs_U.get("custBillId")) : "0";
				taskOrderMap.put("newTaskId", newTaskId);
				taskOrderMap.put("taskBillGroupId", custBillId);
				rentalUnbillBillingMapper.insTaskLogOrder_U(taskOrderMap);
    		}
    		
    		Map<String, Object> taskLogMap = new HashMap<String, Object>();
        	Calendar calendar = Calendar.getInstance();
        	taskLogMap.put("taskType", "MANUAL BILL");
        	taskLogMap.put("billingYear", calendar.get(Calendar.YEAR));
        	taskLogMap.put("billingMonth", calendar.get(Calendar.MONTH)+1);
        	taskLogMap.put("taskTotalAmount", taskTotalAmount);
        	taskLogMap.put("taskCount", taskCount);
        	taskLogMap.put("status", "SUCCESS");
        	taskLogMap.put("isConfirmed", 0);
        	taskLogMap.put("isInvoiceGenerate", 0);
        	taskLogMap.put("createdBy", userId);
        	taskLogMap.put("updatedBy", userId);
        	taskLogMap.put("taskBillRemark", String.valueOf(formMap.get("invoiceRemark")).replace("'","''"));
        	taskLogMap.put("newTaskId", newTaskId);
        	rentalUnbillBillingMapper.insBillTaskLog_U(taskLogMap);
    	}
    	
    	int value= -1;
    	if(newTaskId > 0){
    		
    		Map<String, Object> confMap = new HashMap<String, Object>();
    		confMap.put("taskId", newTaskId);
			confMap.put("userId", userId);
			rentalUnbillBillingMapper.confirmTaxesManualBill(confMap);
    		value=Integer.parseInt(String.valueOf(confMap.get("p1")));
    	}

		return value;
		
	}


}
