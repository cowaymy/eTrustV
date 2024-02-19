package com.coway.trust.biz.payment.payment.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.payment.service.BatchPaymentService;
import com.coway.trust.util.CommonUtils;

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

@Service("batchPaymentService")
public class BatchPaymentServiceImpl extends EgovAbstractServiceImpl implements BatchPaymentService {

	@Resource(name = "batchPaymentMapper")
	private BatchPaymentMapper batchPaymentMapper;

	private static final Logger logger = LoggerFactory.getLogger(BatchPaymentServiceImpl.class);

	/**
	 * selectBatchList(Master Grid) 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectBatchList(Map<String, Object> params) {
		return batchPaymentMapper.selectBatchList(params);
	}

	@Override
	public EgovMap selectBatchPaymentView(Map<String, Object> params) {
		return batchPaymentMapper.selectBatchPaymentView(params);
	}

	@Override
	public List<EgovMap> selectBatchPaymentDetList(Map<String, Object> params) {
		return batchPaymentMapper.selectBatchPaymentDetList(params);
	}

	@Override
	public EgovMap selectTotalValidAmt(Map<String, Object> params) {
		return batchPaymentMapper.selectTotalValidAmt(params);
	}

	@Override
	public int updRemoveItem(Map<String, Object> params) {
		//if is eghl record, possible have multiple order tie into one batchId
		this.removeEGHLBatchOrderRecord(params);
		return batchPaymentMapper.updRemoveItem(params);
	}

	@Override
	public int saveConfirmBatch(Map<String, Object> params) {
		EgovMap  paymentMs = batchPaymentMapper.selectBatchPaymentMs(params);
		int insResult = 0;
		int callResult = -1;
		int returnResult = 0;

	    if (paymentMs != null) {
	        if (String.valueOf(paymentMs.get("batchPayType")).equals("96")
	            || String.valueOf(paymentMs.get("batchPayType")).equals("97")) {
	          // CALL PROCEDURE

	          if (String.valueOf(paymentMs.get("batchIsAdv")).equals("1")) {
	            batchPaymentMapper.callCnvrAdvBatchPay(params);
	          } else {
	            batchPaymentMapper.callCnvrBatchPay(params);
	          }

	          callResult = Integer.parseInt(String.valueOf(params.get("p1")));
	        }
	        if (callResult > -1) {
	          if (String.valueOf(paymentMs.get("batchStusId")).equals("1")
	              && String.valueOf(paymentMs.get("cnfmStusId")).equals("44")) {

	            insResult = batchPaymentMapper.saveConfirmBatch(params);

	          }
	        }
	      }

		if(insResult > 0 && callResult > -1){
			//for eghl record checking and update
			returnResult = 1;
		}else{
			returnResult = 0;
		}

		return returnResult;
	}

	@Override
	public EgovMap selectBatchPaymentDs(Map<String, Object> params) {
		return batchPaymentMapper.selectBatchPaymentDs(params);
	}

	@Override
	public int saveDeactivateBatch(Map<String, Object> params) {
		return batchPaymentMapper.saveDeactivateBatch(params);
	}

	@Override
	public EgovMap selectBatchPaymentMs(Map<String, Object> params) {
		return batchPaymentMapper.selectBatchPaymentMs(params);
	}

	@Override
	public int saveBatchPaymentUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {
		int insResult = 0;
		int mastetSeq = 0;
		if(master.get("isBatch") != null && master.get("batchId") != null){
			mastetSeq = Integer.parseInt(master.get("batchId").toString());
		}else{
			mastetSeq = batchPaymentMapper.getPAY0044DSEQ();
		}
		master.put("batchId", mastetSeq);
		int mResult = batchPaymentMapper.saveBatchPayMaster(master);

/*		if(mResult > 0 && detailList.size() > 0){
			for(int i=0 ; i < detailList.size() ; i++){
				int detailSeq = batchPaymentMapper.getPAY0043DSEQ();
				detailList.get(i).put("detId", detailSeq);
				detailList.get(i).put("batchId", mastetSeq);
				detailList.get(i).put("jomPay", master.get("jomPay"));

				logger.debug("detailList {}",detailList.get(i));
				batchPaymentMapper.saveBatchPayDetailList(detailList.get(i));
			}
			//CALL PROCEDURE
			batchPaymentMapper.callBatchPayVerifyDet(master);
		}*/

		if(mResult > 0 && detailList.size() > 0){
		  List  buLit = new ArrayList();
      for(int i=0 ; i < detailList.size() ; i++){
        int detailSeq = batchPaymentMapper.getPAY0043DSEQ();

        detailList.get(i).put("detId", detailSeq);
        detailList.get(i).put("batchId", mastetSeq);
        detailList.get(i).put("jomPay", master.get("jomPay"));
        logger.debug("========= detId :: " + detailSeq);
        logger.debug("============= detailList {}  ",detailList.get(i));
        //batchPaymentMapper.saveBatchPayDetailList(detailList.get(i));
         buLit.add(detailList.get(i));
      }

      master.put("list", buLit);
      batchPaymentMapper.saveBatchPayDetailList(master);


      //CALL PROCEDURE
      insResult = batchPaymentMapper.callBatchPayVerifyDet(master);
      if(!master.get("p1").toString().equals("1")){
    	  mastetSeq = -1;
      }
    }

    return mastetSeq;

	}

	@Override
	public String selectBatchPayCardModeId(String cardModeCode) {
		return batchPaymentMapper.selectBatchPayCardModeId(cardModeCode);
	}

	@Override
	public int removeEGHLBatchOrderRecord(Map<String, Object> params) {
		int count = batchPaymentMapper.checkIfIsEGHLRecord(params);

		if(count > 0){
			batchPaymentMapper.removeEGHLBatchOrderRecord(params);
		}
		return 1;
	}
}
