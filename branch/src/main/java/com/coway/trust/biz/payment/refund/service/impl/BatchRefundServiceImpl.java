package com.coway.trust.biz.payment.refund.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.refund.service.BatchRefundService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("batchRefundService")
public class BatchRefundServiceImpl implements BatchRefundService {
	
	@Resource(name = "batchRefundMapper")
	private BatchRefundMapper batchRefundMapper;

	@Override
	public List<EgovMap> selectBatchRefundList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return batchRefundMapper.selectBatchRefundList(params);
	}

	@Override
	public EgovMap selectBatchRefundInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		EgovMap bRefundInfo = batchRefundMapper.selectBatchRefundInfo(params);
		List<EgovMap> bRefundItem = batchRefundMapper.selectBatchRefundItem(params);
		
		int totalInvalid = 0;
		double totalValidAmt = 0;
		for (EgovMap egovMap : bRefundItem) {
			if(Integer.parseInt(String.valueOf(egovMap.get("validStusId"))) == 21) {
				totalInvalid = totalInvalid + 1;
			} else if (Integer.parseInt(String.valueOf(egovMap.get("validStusId"))) == 4) {
				totalValidAmt = totalValidAmt + Double.parseDouble(String.valueOf(egovMap.get("amt")));
			}
		}
		
		bRefundInfo.put("totalItem", bRefundItem.size());
		bRefundInfo.put("totalInvalid", totalInvalid);
		bRefundInfo.put("totalValid", bRefundItem.size() - totalInvalid);
		bRefundInfo.put("totalValidAmt", totalValidAmt);
		bRefundInfo.put("bRefundItem", bRefundItem);
		
		return bRefundInfo;
	}

	@Override
	public List<EgovMap> selectBatchRefundItem(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return batchRefundMapper.selectBatchRefundItem(params);
	}

	@Override
	public List<EgovMap> selectAccNoList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return batchRefundMapper.selectAccNoList(params);
	}

	@Override
	public int saveBatchRefundUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {
		// TODO Auto-generated method stub
		int mastetSeq = batchRefundMapper.selectNextBatchId();
		master.put("batchId", mastetSeq);
		int mResult = batchRefundMapper.insertBatchRefundM(master);
		
		if(mResult > 0 && detailList.size() > 0){
			for(int i=0 ; i < detailList.size() ; i++){
				int detailSeq = batchRefundMapper.selectNextDetId();
				detailList.get(i).put("detId", detailSeq);
				detailList.get(i).put("batchId", mastetSeq);
				batchRefundMapper.insertBatchRefundD(detailList.get(i));
			}
			//CALL PROCEDURE
			batchRefundMapper.callBatchRefundVerifyDet(master);
		}
		return mastetSeq;
	}

	@Override
	public int batchRefundDeactivate(Map<String, Object> master) {
		// TODO Auto-generated method stub
		EgovMap bRefundInfo = batchRefundMapper.selectBatchRefundInfo(master);
		
		if(!bRefundInfo.isEmpty()) {
			if(Integer.parseInt(String.valueOf(bRefundInfo.get("batchStusId"))) == 1) {
				return batchRefundMapper.batchRefundDeactivate(master);
			}
		}
		return 0;
	}

	@Override
	public int batchRefundConfirm(Map<String, Object> master, Boolean isConvert) {
		// TODO Auto-generated method stub
		EgovMap bRefundInfo = batchRefundMapper.selectBatchRefundInfo(master);
		List<EgovMap> bRefundItem = batchRefundMapper.selectBatchRefundItem(master);
		int result = 0;
		
		if(!bRefundInfo.isEmpty()) {
			if(Integer.parseInt(String.valueOf(bRefundInfo.get("batchStusId"))) == 1 && Integer.parseInt(String.valueOf(bRefundInfo.get("cnfmStusId"))) == 44) {
				result = batchRefundMapper.batchRefundConfirm(master);
				
				if(isConvert) {
					//CALL PROCEDURE
					batchRefundMapper.callConvertBatchRefund(master);
				}
				
				for (EgovMap egovMap : bRefundItem) {
					String ifKey = batchRefundMapper.selectNextIfKey();
					egovMap.put("ifKey", ifKey);
					egovMap.put("refnDate", bRefundInfo.get("crtDt"));
					egovMap.put("userId", master.get("userId"));
					// INSERT INTERFACE
					batchRefundMapper.insertInterface(egovMap);
				}
				
				return result;
			}
		}
		return result;
	}

	@Override
	public int batchRefundItemDisab(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return batchRefundMapper.batchRefundItemDisab(params);
	}

}
