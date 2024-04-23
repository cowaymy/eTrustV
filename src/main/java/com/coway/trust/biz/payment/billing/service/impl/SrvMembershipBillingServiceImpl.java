package com.coway.trust.biz.payment.billing.service.impl;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.billing.service.SrvMembershipBillingService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.datasource.DataSource;
import com.coway.trust.config.datasource.DataSourceType;
import com.ibm.icu.text.DecimalFormat;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("srvMembershipBillingService")
public class SrvMembershipBillingServiceImpl extends EgovAbstractServiceImpl implements SrvMembershipBillingService {

	private static final Logger logger = LoggerFactory.getLogger(SrvMembershipBillingServiceImpl.class);

	@Resource(name = "advRentalBillingMapper")
	private AdvRentalBillingMapper advRentalBillingMapper;

	@Resource(name = "srvMembershipBillingMapper")
	private SrvMembershipBillingMapper srvMembershipBillingMapper;


	/**
	 * Manual Billing - Membership save 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	@DataSource(value = DataSourceType.LONG_TIME)
	public int saveSrvMembershipBilling(Map<String, Object> formData, List<Object> taskBillList, SessionVO sessionVO) {

		int userId = sessionVO.getUserId();
		int taskCount = 0;

    	double taskTotalAmount = 0.00;
    	int resultVal = 97;
    	Map<String, Object> taskOrderMap = new HashMap<String, Object>();

    	//NEW TASK ID 조회
    	int newTaskId = advRentalBillingMapper.getTaskIdSeq();

    	if(taskBillList.size() > 0){

    		Map<String, Object> hm = null;

    		for (int i=0; i< taskBillList.size() ; i++) {
    			hm = (HashMap) taskBillList.get(i);

    			taskCount = taskCount + 1;
    			taskTotalAmount = taskTotalAmount + Double.parseDouble(String.valueOf(hm.get("totalAmt")));

    			double billAmt =  hm.get("totalAmt") != null ? Double.parseDouble(String.valueOf(hm.get("totalAmt"))) : 0;

    			taskOrderMap.put("salesOrdId", String.valueOf(hm.get("salesOrdId")));
    			taskOrderMap.put("taskReferenceNo", String.valueOf(formData.get("poNo")).replace("'","''"));
    			taskOrderMap.put("taskBillTypeId", 223);
    			taskOrderMap.put("taskBillUpdateBy", userId);
                taskOrderMap.put("taskBillAmt", new DecimalFormat("0.00").format(billAmt));
                taskOrderMap.put("taskBillInstNo", 0);
                taskOrderMap.put("taskBillBatchNo", String.valueOf(hm.get("srvMemQuotNo")));
                taskOrderMap.put("taskBillGroupId", 0);
                taskOrderMap.put("taskBillRemark", String.valueOf(formData.get("remark")).replace("'","''"));
                taskOrderMap.put("taskBillUpdateBy", userId);
                taskOrderMap.put("taskBillZRLocationId", 0);
                taskOrderMap.put("taskBillReliefCertificateId", 0);
                taskOrderMap.put("taskBillCnrctId", 0);
                taskOrderMap.put("newTaskId", newTaskId);
                // Added Reference No. by Hui Ding, 2021-08-01
                taskOrderMap.put("taskSmqRefNo", String.valueOf(formData.get("refNo")).replace("'","''"));

                //BILL CREATE - PAY0048D INSERT
				advRentalBillingMapper.insTaskLogOrder(taskOrderMap);
    		}

    		Map<String, Object> taskLogMap = new HashMap<String, Object>();
        	Calendar calendar = Calendar.getInstance();
        	taskLogMap.put("taskType", "MEMBERSHIP BILL");
        	taskLogMap.put("billingYear", calendar.get(Calendar.YEAR));
        	taskLogMap.put("billingMonth", calendar.get(Calendar.MONTH)+1);
        	taskLogMap.put("taskTotalAmount", taskTotalAmount);
        	taskLogMap.put("taskCount", taskCount);
        	taskLogMap.put("status", "SUCCESS");
        	taskLogMap.put("isConfirmed", 0);
        	taskLogMap.put("isInvoiceGenerate", 0);
        	taskLogMap.put("createdBy", userId);
        	taskLogMap.put("updatedBy", userId);
        	taskLogMap.put("taskBillRemark", String.valueOf(formData.get("invoiceRemark")).replace("'","''"));
        	taskLogMap.put("newTaskId", newTaskId);

        	//BILL CREATE - PAY0047D INSERT
    		advRentalBillingMapper.insBillTaskLog(taskLogMap);
    	}

    	int confirmVal= -1;
    	int invcVal = -1;

    	if(newTaskId > 0){

    		Map<String, Object> confMap = new HashMap<String, Object>();
    		confMap.put("taskId", newTaskId);
    		confMap.put("userId", userId);

    		//BILL CREATION CONFIRM
    		srvMembershipBillingMapper.confirmSrvMembershipBilll(confMap);
    		confirmVal=Integer.parseInt(String.valueOf(confMap.get("p1")));

    		if(confirmVal == 1){
    			Map<String, Object> invoiceMap = new HashMap<String, Object>();
    			invoiceMap.put("taskId", newTaskId);
    			invoiceMap.put("userId", userId);

    			//CREATE TAX INVOICE : MEMBERSHIP
    			srvMembershipBillingMapper.createTaxInvoice(invoiceMap);
    			invcVal=Integer.parseInt(String.valueOf(invoiceMap.get("p1")));

    			//프로시저 성공시 최종성공 , 실패시 99코드 반환
    			resultVal = invcVal == 1 ? 1 : 99;

    		}else{
    			//프로시저 실패시 98코드 반환
    			resultVal = 98;
    		}
    	}

		return resultVal;
	}

}
