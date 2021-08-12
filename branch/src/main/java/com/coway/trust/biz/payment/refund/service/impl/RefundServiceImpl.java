package com.coway.trust.biz.payment.refund.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.refund.service.RefundService;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("refundService")
public class RefundServiceImpl implements RefundService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RefundServiceImpl.class);
	
	@Resource(name = "refundMapper")
	private RefundMapper refundMapper;

	
	@Override
	public List<EgovMap> selectRefundList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return refundMapper.selectRefundList(params);
	}


	@Override
	public EgovMap selectRefundInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<Object> batchIdList = (List<Object>) params.get("batchIdList");
		
		int totalItem = 0;
		int totalInvalid = 0;
		int totalValidAmt = 0;
		int totalInvalidAmt = 0;
		EgovMap result = new EgovMap();
		List<Object> gridDataList = new ArrayList();
		for(int i = 0; i< batchIdList.size(); i++) {
			Map<String, Object> batchId = new HashMap<String, Object>();
			batchId.put("batchId", batchIdList.get(i));
			
			EgovMap bRefundInfo = refundMapper.selectRefundInfo(batchId);
			List<EgovMap> bRefundItem = refundMapper.selectRefundItem(batchId);
			
			totalItem = totalItem + bRefundItem.size();
			
			for (EgovMap egovMap : bRefundItem) {
				if(Integer.parseInt(String.valueOf(egovMap.get("validStusId"))) == 21) {
					totalInvalid = totalInvalid + 1;
					totalInvalidAmt = totalInvalidAmt + Integer.parseInt(String.valueOf(egovMap.get("amt")));
				} else if (Integer.parseInt(String.valueOf(egovMap.get("validStusId"))) == 4) {
					totalValidAmt = totalValidAmt + Integer.parseInt(String.valueOf(egovMap.get("amt")));
				}
				egovMap.put("refModeId", bRefundInfo.get("refundModeId"));
				egovMap.put("refModeName", bRefundInfo.get("codeName"));
			}
			
			gridDataList.add(bRefundItem);
		}
		
		result.put("totalItem", totalItem);
		result.put("totalAmt", totalValidAmt + totalInvalidAmt);
		result.put("totalInvalid", totalInvalid);
		result.put("totalInvalidAmt", totalInvalidAmt);
		result.put("totalValid", totalItem - totalInvalid);
		result.put("totalValidAmt", totalValidAmt);
		result.put("gridDataList", gridDataList);
		
		
		return result;
	}


	@Override
	public List<EgovMap> selectCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return refundMapper.selectCodeList(params);
	}


	@Override
	public List<EgovMap> selectBankCode() {
		// TODO Auto-generated method stub
		return refundMapper.selectBankCode();
	}
	
	
	
	

}
