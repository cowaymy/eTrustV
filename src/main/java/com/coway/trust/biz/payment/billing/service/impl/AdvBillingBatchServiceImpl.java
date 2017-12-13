package com.coway.trust.biz.payment.billing.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.payment.billing.service.AdvBillingBatchService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2017.10.30 최초생성
 
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2017.10.31
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("advBillingBatchService")
public class AdvBillingBatchServiceImpl extends EgovAbstractServiceImpl implements AdvBillingBatchService {

	@Resource(name = "advBillingBatchMapper")
	private AdvBillingBatchMapper advBillingBatchMapper;
	
	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Override
	public List<EgovMap> selectBillingBatch(Map<String, Object> params) {
		return advBillingBatchMapper.selectBillingBatch(params);
	}

	@Override
	public EgovMap selectSalesOrderMaster(String params) {
		return advBillingBatchMapper.selectSalesOrderMaster(params);
	}

	@Override
	public boolean isCheckOrderNoIsExistAndRentalType(String param) {
		// TODO Auto-generated method stub
		boolean re = false;
		EgovMap em = this.selectSalesOrderMaster(param);
		if(em != null) re = true;
		return re;
	}
	
	@Override
	@Transactional
	public boolean doSaveBatchAdvBilling(Map<String, Object> advBillBatchM,
			List<Map<String, Object>> advBillBatchList) {
		boolean issuccess = false;
		
		String batchRefNo = "";
		double totalAmount = 0;
		double totalDiscount = 0;
		
		batchRefNo = commonMapper.selectDocNo("141");
		advBillBatchM.put("advBillBatchRefNo", batchRefNo);
		
		System.out.println("Master : " + advBillBatchM);
		this.insertAccAdvanceBillBatchM(advBillBatchM);
		String batchId = String.valueOf(advBillBatchM.get("advBillBatchId"));
		
		for(Map<String, Object> det : advBillBatchList){
			
			det.put("accBillBatchId", batchId);
			EgovMap em = this.selectSalesOrderMaster(String.valueOf(det.get("accBatchItemOrderNo")));
			det.put("accBatchItemOrderId", em.get("salesOrdId"));
			det.put("accBatchItemBillAmount", Double.parseDouble(String.valueOf(em.get("mthRentAmt"))));
		
			System.out.println("Detail : " + det);
			this.insertAccAdvanceBillBatchD(det);
			
			totalAmount += Double.parseDouble(String.valueOf(det.get("accBatchItemBillAmount")));
			totalDiscount += Double.parseDouble(String.valueOf(det.get("accBatchItemBillDiscount")));
		}
		
		advBillBatchM.put("advBillBatchTotal", totalAmount);
		advBillBatchM.put("advBillBatchTotalDiscount", totalDiscount);
		
		System.out.println("update Master : " + advBillBatchM);
		this.updateAccAdvanceBillBatchM(advBillBatchM);
		
		issuccess = true;
		
		return issuccess;
	}

	@Override
	public void insertAccAdvanceBillBatchM(Map<String, Object> params) {
		advBillingBatchMapper.insertAccAdvanceBillBatchM(params);
	}

	@Override
	public void insertAccAdvanceBillBatchD(Map<String, Object> params) {
		advBillingBatchMapper.insertAccAdvanceBillBatchD(params);
	}

	@Override
	public void updateAccAdvanceBillBatchM(Map<String, Object> params) {
		advBillingBatchMapper.updateAccAdvanceBillBatchM(params);
	}

	@Override
	public EgovMap selectBatchMasterInfo(Map<String, Object> params) {
		return advBillingBatchMapper.selectBatchMasterInfo(params);
	}

	@Override
	public List<EgovMap> selectBatchDetailInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return advBillingBatchMapper.selectBatchDetailInfo(params);
	}

	@Override
	public boolean doDeactivateAdvanceBillBatach(Map<String, Object> params) {
		boolean success = false;
		
		System.out.println("paramsForMaster : " + params);
		EgovMap em = advBillingBatchMapper.selectBatchMasterInfo(params);
		
		if(em != null){
			this.advBillingBatchMapper.updateAccAdvanceBillBatchM2(params);
			
			List<EgovMap> list = advBillingBatchMapper.selectBatchDetailInfo(params);
			
			if(list.size() > 0){
				for(EgovMap map : list){
					params.put("itemId", map.get("accBatchItmId"));
					System.out.println("paramsForDetail : " + params);
					this.advBillingBatchMapper.updateAccAdvanceBillBatchD2(params);
				}
			}
			success = true;
		}
		return success;
	}

	@Override
	public void updateAccAdvanceBillBatchM2(Map<String, Object> params) {
		advBillingBatchMapper.updateAccAdvanceBillBatchM2(params);
	}

	@Override
	public void updateAccAdvanceBillBatchD2(Map<String, Object> params) {
		advBillingBatchMapper.updateAccAdvanceBillBatchD2(params);
	}

	@Override
	public boolean updBillBatchUpload(Map<String, Object> params) {
		int updResult = -1;
		advBillingBatchMapper.updBillBatchUpload(params);
		updResult = Integer.parseInt(String.valueOf(params.get("p1")));
		
		if(updResult > 0){
			return true;
		}else{
			return false;
		}
	}
}
