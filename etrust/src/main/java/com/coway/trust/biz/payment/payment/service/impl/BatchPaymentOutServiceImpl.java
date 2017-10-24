package com.coway.trust.biz.payment.payment.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.payment.service.BatchPaymentOutService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

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

@Service("batchPaymentOutService")
public class BatchPaymentOutServiceImpl extends EgovAbstractServiceImpl implements BatchPaymentOutService {

	@Resource(name = "batchPaymentOutMapper")
	private BatchPaymentOutMapper batchPaymentOutMapper;
	
	@Resource(name = "batchPaymentMapper")
	private BatchPaymentMapper batchPaymentMapper;
	
	private static final Logger logger = LoggerFactory.getLogger(BatchPaymentOutServiceImpl.class);
	
	@Override
	public int saveBatchPaymentOutUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {
		int mastetSeq = batchPaymentMapper.getPAY0044DSEQ();
		master.put("batchId", mastetSeq);
		int mResult = batchPaymentMapper.saveBatchPayMaster(master);
		if(mResult > 0 && detailList.size() > 0){
			for(int i=0 ; i < detailList.size() ; i++){
				int detailSeq = batchPaymentMapper.getPAY0043DSEQ();
				detailList.get(i).put("detId", detailSeq);
				detailList.get(i).put("batchId", mastetSeq);
				batchPaymentMapper.saveBatchPayDetailList(detailList.get(i));
				logger.debug("detailList=== "+ (i+1) +"번째 === "+detailList.get(i));
			}
			//CALL PROCEDURE
			batchPaymentOutMapper.callBatchPayVerifyDetInStf(master);
		}
		
		return mastetSeq;
	}

}
