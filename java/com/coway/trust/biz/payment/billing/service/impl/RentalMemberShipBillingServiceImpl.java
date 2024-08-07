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

import com.coway.trust.biz.payment.billing.service.RentalMemberShipBillingService;
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

@Service("rentalMemberShipBillingService")
public class RentalMemberShipBillingServiceImpl extends EgovAbstractServiceImpl implements RentalMemberShipBillingService {

	private static final Logger logger = LoggerFactory.getLogger(RentalMemberShipBillingServiceImpl.class);

	@Resource(name = "rentalMemberShipBillingMapper")
	private RentalMemberShipBillingMapper rentalMemberShipBillingMapper ;

	/**
	 * selectCustBillOrderNoList_M 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectCustBillOrderList_M(Map<String, Object> params) {
		return rentalMemberShipBillingMapper.selectCustBillOrderList_M(params);
	}
	
	/**
	 * selectUnbilledRentalBillingSchedule_M 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectRentalMembershipBillingSchedule(Map<String, Object> params) {
		return rentalMemberShipBillingMapper.selectRentalMembershipBillingSchedule(params);
	}
	
	/**
	 * confirmTaxesManualBillRentalMbrsh (INSERT + CALL PROCEDURE)
	 * @param params
	 * @return
	 */
	@Transactional
	public int confirmTaxesManualBillRentalMbrsh(List<Object> formList, List<Object> taskBillList, SessionVO sessionVO) {
		
		int userId = sessionVO.getUserId();
    	int taskCount = 0;
    	double taskTotalAmount = 0;
    	Map<String, Object> taskOrderMap = new HashMap<String, Object>();
    	Map<String, Object> formMap = (Map<String, Object>)formList.get(0);
    	int newTaskId = rentalMemberShipBillingMapper.getTaskIdSeq_M();
		
    	if(taskBillList.size() > 0){
    		
    		Map<String, Object> hm = null;
    		
    		for (int i=0; i< taskBillList.size() ; i++) {
    			hm = (HashMap) taskBillList.get(i);
    			
    			taskCount = taskCount + 1;
    			taskTotalAmount = taskTotalAmount + Double.parseDouble(String.valueOf(hm.get("billAmt")));
    			
    			taskOrderMap.put("salesOrdId", String.valueOf(hm.get("salesOrdId")));
    			taskOrderMap.put("taskReferenceNo", "");
    			
                if (String.valueOf(hm.get("billType")).equals("ServiceContractRentalBill")){
                    taskOrderMap.put("taskBillTypeId", 1305);
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
                taskOrderMap.put("taskBillCnrctId", String.valueOf(formMap.get("srvCntrctId")));
                
                EgovMap  selectSalesOrderMs_M = rentalMemberShipBillingMapper.selectSalesOrderMs_M(hm);
				String custBillId = selectSalesOrderMs_M.get("custBillId") != null ? String.valueOf(selectSalesOrderMs_M.get("custBillId")) : "0";
				taskOrderMap.put("newTaskId", newTaskId);
				taskOrderMap.put("taskBillGroupId", custBillId);
				rentalMemberShipBillingMapper.insTaskLogOrder_M(taskOrderMap);
    		}
    		
    		Map<String, Object> taskLogMap = new HashMap<String, Object>();
        	Calendar calendar = Calendar.getInstance();
        	taskLogMap.put("taskType", "MANUAL REN-MEM BILL");
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
        	rentalMemberShipBillingMapper.insBillTaskLog_M(taskLogMap);
    	}
    	
    	int value= -1;
    	if(newTaskId > 0){
    		
    		Map<String, Object> confMap = new HashMap<String, Object>();
    		confMap.put("taskId", newTaskId);
			confMap.put("userId", userId);
			rentalMemberShipBillingMapper.confirmTaxesManualBillRentalMbrsh(confMap);
    		value=Integer.parseInt(String.valueOf(confMap.get("p1")));
    	}

		return value;
		
	}


}
