package com.coway.trust.biz.supplement.payment.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.supplement.payment.service.SupplementBatchRefundService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("supplementBatchRefundService")
public class SupplementBatchRefundServiceImpl implements SupplementBatchRefundService {

	@Resource(name = "supplementBatchRefundMapper")
	private SupplementBatchRefundMapper supplementBatchRefundMapper;

	@Override
	public List<EgovMap> selectBatchRefundList(Map<String, Object> params) {
		return supplementBatchRefundMapper.selectBatchRefundList(params);
	}

	@Override
	public EgovMap selectBatchRefundInfo(Map<String, Object> params) {
		EgovMap bRefundInfo = supplementBatchRefundMapper.selectBatchRefundInfo(params);
		List<EgovMap> bRefundItem = supplementBatchRefundMapper.selectBatchRefundItem(params);

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
		return supplementBatchRefundMapper.selectBatchRefundItem(params);
	}

	@Override
	public List<EgovMap> selectAccNoList(Map<String, Object> params) {
		return supplementBatchRefundMapper.selectAccNoList(params);
	}

	@Override
  public List<EgovMap> selectCodeList(Map<String, Object> params) {
    return supplementBatchRefundMapper.selectCodeList(params);
  }

	@Override
	public int saveBatchRefundUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {
    int result = 0;
		int mastetSeq = supplementBatchRefundMapper.selectNextBatchId();
		master.put("batchId", mastetSeq);
		master.put("delFlg", "N");
		int mResult = supplementBatchRefundMapper.insertBatchRefundM(master);

		if(mResult > 0 && detailList.size() > 0){
			for(int i=0 ; i < detailList.size() ; i++){
				int detailSeq = supplementBatchRefundMapper.selectNextDetId();
				detailList.get(i).put("detId", detailSeq);
				detailList.get(i).put("batchId", mastetSeq);
				detailList.get(i).put("delFlg", "N");
				supplementBatchRefundMapper.insertBatchRefundD(detailList.get(i));
			}

			//CALL PROCEDURE
			result = supplementBatchRefundMapper.callBatchRefundVerifyDet(master);
			 if (!master.get( "p1" ).toString().equals("1")) {
	        mastetSeq = -1;
	     }
		}
		return mastetSeq;
	}

	@Override
	public int batchRefundDeactivate(Map<String, Object> master) {
		EgovMap bRefundInfo = supplementBatchRefundMapper.selectBatchRefundInfo(master);

		if(!bRefundInfo.isEmpty()) {
			if(Integer.parseInt(String.valueOf(bRefundInfo.get("batchStusId"))) == 1) {
				return supplementBatchRefundMapper.batchRefundDeactivate(master);
			}
		}

		return 0;
	}

	@Override
	public int batchRefundConfirm(Map<String, Object> master, Boolean isConvert) {
		EgovMap bRefundInfo = supplementBatchRefundMapper.selectBatchRefundInfo(master);
		List<EgovMap> bRefundItem = supplementBatchRefundMapper.selectBatchRefundItem(master);
		int result = 0;
		int callResult = -1;

		if(!bRefundInfo.isEmpty()) {
		  if(isConvert) {
        //CALL PROCEDURE
        supplementBatchRefundMapper.callConvertBatchRefund(master);
        callResult = Integer.parseInt(String.valueOf(master.get("p1")));
      }

			if(callResult > -1){
				if(Integer.parseInt(String.valueOf(bRefundInfo.get("batchStusId"))) == 1 && Integer.parseInt(String.valueOf(bRefundInfo.get("cnfmStusId"))) == 44) {
				   result = supplementBatchRefundMapper.batchRefundConfirm(master);

				   //update the SUP0001M > SUP_RTN_RFND = Y after success confirm batch refund
				   List<EgovMap> supBatchRefundDtl = supplementBatchRefundMapper.selectSupBatchRefundDtl(master);
				   if (supBatchRefundDtl.size() > 0) {
				     for ( int i = 0; i < supBatchRefundDtl.size(); i++ ) {
				        Map<String, Object> updMap = (Map<String, Object>) supBatchRefundDtl.get(i);
			          updMap.put("userId", master.get("userId").toString());
			          result = supplementBatchRefundMapper.updSupplementRtnRfnd(updMap);
				     }
				   }

				   for (EgovMap egovMap : bRefundItem) {
		          String ifKey = supplementBatchRefundMapper.selectNextIfKey();
		          egovMap.put("ifKey", ifKey);
		          egovMap.put("refnDate", bRefundInfo.get("crtDt"));
		          egovMap.put("userId", master.get("userId"));
		          // INSERT INTERFACE
		          supplementBatchRefundMapper.insertInterface(egovMap);
		        }

		        return result;
		      }
			}
		}
		return result;
	}

	@Override
	public int batchRefundItemDisab(Map<String, Object> params) {
		return supplementBatchRefundMapper.batchRefundItemDisab(params);
	}

	@Override
  public List<EgovMap> getPaymentMode() {
    return supplementBatchRefundMapper.getPaymentMode();
  }

  @Override
  public List<EgovMap> getBatStatus() {
    return supplementBatchRefundMapper.getBatStatus();
  }

  @Override
  public List<EgovMap> getBatConfirmtStatus() {
    return supplementBatchRefundMapper.getBatConfirmtStatus();
  }

  @Override
  public List<EgovMap> selectSupOrdList(String borNo) {
    return supplementBatchRefundMapper.selectSupOrdList(borNo);
  }

}
