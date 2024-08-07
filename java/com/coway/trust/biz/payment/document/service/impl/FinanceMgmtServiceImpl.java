package com.coway.trust.biz.payment.document.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.payment.payment.service.CommDeductionService;
import com.coway.trust.biz.payment.document.service.FinanceMgmtService;
import com.coway.trust.biz.payment.payment.service.PayDVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;
import com.coway.trust.biz.payment.payment.service.SearchPaymentService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.SimpleDateFormat;

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

@Service("financeMgmtService")
public class FinanceMgmtServiceImpl extends EgovAbstractServiceImpl implements FinanceMgmtService{

	@Resource(name = "financeMgmtMapper")
	private FinanceMgmtMapper financeMgmtMapper;

	@Override
	public List<EgovMap> selectReceiveList(Map<String, Object> params) {
		return financeMgmtMapper.selectReceiveList(params);
	}

	@Override
	public List<EgovMap> selectCreditCardList(Map<String, Object> params) {
		return financeMgmtMapper.selectCreditCardList(params);
	}

	@Override
	public List<EgovMap> selectDocItemPaymentItem(Map<String, Object> params) {
		return financeMgmtMapper.selectDocItemPaymentItem(params);
	}

	@Override
	public List<EgovMap> selectLogItemPaymentItem(Map<String, Object> params) {
		return financeMgmtMapper.selectLogItemPaymentItem(params);
	}

	@Override
	public List<EgovMap> selectPayDocBatchById(Map<String, Object> params) {
		return financeMgmtMapper.selectPayDocBatchById(params);
	}

	@Override
	public List<EgovMap> selectDocItemPaymentItem2(Map<String, Object> params) {
		return financeMgmtMapper.selectDocItemPaymentItem2(params);
	}

	@Override
	public List<EgovMap> selectPayDocumentDetail(Map<String, Object> params) {
		return financeMgmtMapper.selectPayDocumentDetail(params);
	}

	@Override
	@Transactional
	public Map<String, Object> savePayDoc(List<Map<String, Object>> list, String remark) {
		Date curdate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String today = sdf.format(curdate);
		String defaultDate = "1900-01-01 00:00:00";
		Map<String, Object> reValue = new HashMap<String, Object>();
		int cnt = 0;
		
		if(list.size() > 0){
			for(Map<String, Object> det : list){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("itemId", det.get("itemId"));
				EgovMap qryDet = financeMgmtMapper.selectPayDocumentDetail(map).get(0);
				
				if(qryDet != null){
					Map<String, Object> updateInfo = new HashMap<String, Object>();
					updateInfo.put("itemId", map.get("itemId"));
					updateInfo.put("itemStatusId", det.get("itemStatusId"));
					updateInfo.put("updated", det.get("updated"));
					updateInfo.put("updator", det.get("updator"));
					System.out.println("updateInfo : " + updateInfo);
					this.updatePayDocDetail(updateInfo);
					
					Map<String, Object> log = new HashMap<String, Object>();
					log.put("logId", 0);
					log.put("itemId", det.get("itemId"));
					log.put("remark", remark);
					log.put("created", det.get("updated"));
					log.put("creator", det.get("updator"));
					log.put("sendDate", String.valueOf(det.get("itemStatusId")).equals("79") ? today : defaultDate);
					log.put("reviewDate", String.valueOf(det.get("itemStatusId")).equals("53") ? today : defaultDate);
					log.put("incompleteDate", String.valueOf(det.get("itemStatusId")).equals("50") ? today : defaultDate);
					log.put("completeDate", String.valueOf(det.get("itemStatusId")).equals("4") ? today : defaultDate);
					log.put("statusCodeId", det.get("itemStatusId"));
					System.out.println("log :" + log);
					this.insertPaymentDocLog(log);
				}
			}
			
			List<String> tmp= new ArrayList<String>();
			for(int i=0; i<list.size(); i++)
				tmp.add(String.valueOf(list.get(i).get("batchId")));
			
			List<String> batchList = new ArrayList<String>();
			batchList = tmp.parallelStream().distinct().collect(Collectors.toList());
			
			
			for(String batchId : batchList){
				Map<String, Object> batchType = new HashMap<String, Object>();
				batchType.put("batchId", batchId);
				
				batchType.put("statusId", "4");
				int totalComplete = this.countPayDocDetail(batchType);
				batchType.put("statusId", "50");
				int totalIncomplete = this.countPayDocDetail(batchType);
				batchType.put("statusId", "60");
				int totalPending = this.countPayDocDetail(batchType);
				batchType.put("statusId", "53");
				int totalReview = this.countPayDocDetail(batchType);
				batchType.put("statusId", "33");
				int totalNew = this.countPayDocDetail(batchType);
				batchType.put("statusId", "79");
				int totalResend = this.countPayDocDetail(batchType);
				
				Map<String, Object> batchInfo = new HashMap<String, Object>();
				batchInfo.put("batchId", batchId);
				batchInfo.put("batchTotNew", totalNew);
				batchInfo.put("batchTotComplete", totalComplete);
				batchInfo.put("batchTotIncomplete", totalIncomplete);
				batchInfo.put("batchTotPending", totalPending);
				batchInfo.put("batchTotReview", totalReview);
				batchInfo.put("batchTotResend", totalResend);
				batchInfo.put("updDt", today);
				batchInfo.put("userId", list.get(0).get("updator"));
				
				if(totalNew == 0 && totalReview == 0 && totalPending ==0 && totalResend == 0){
					batchInfo.put("statusId", 36);
					if(totalIncomplete > 0)
						batchInfo.put("batchResultStatusId", 20);
					else
						batchInfo.put("batchResultStatusId", 4);	
					
					cnt++;
				}else{
					batchInfo.put("statusId", 1);
					batchInfo.put("batchResultStatusId", 0);	
				}
				System.out.println("batchInfo : " + batchInfo);
				this.updatePayDocMaster(batchInfo);
			}
		}
		
		reValue.put("count", cnt);
		reValue.put("success", true);
		
		return reValue;
	}

	@Override
	public void updatePayDocDetail(Map<String, Object> params) {
		financeMgmtMapper.updatePayDocDetail(params);
	}

	@Override
	public void insertPaymentDocLog(Map<String, Object> params) {
		financeMgmtMapper.insertPaymentDocLog(params);
	}

	@Override
	public int countPayDocDetail(Map<String, Object> params) {
		return financeMgmtMapper.countPayDocDetail(params);
	}

	@Override
	public void updatePayDocMaster(Map<String, Object> params) {
		financeMgmtMapper.updatePayDocMaster(params);
	}

}
