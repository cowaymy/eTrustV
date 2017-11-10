package com.coway.trust.biz.logistics.inbound.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.inbound.InboundService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("inboundService")
public class InboundServiceImple extends EgovAbstractServiceImpl implements InboundService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "inboundMapper")
	private InboundMapper inboundMapper;

	@Override
	public List<EgovMap> inBoundList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return inboundMapper.inBoundList(params);
	}

	@Override
	public List<EgovMap> inboundLocation(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return inboundMapper.inboundLocation(params);
	}

	@Override
	public List<EgovMap> receiptList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return inboundMapper.receiptList(params);
	}

	@Override
	public List<EgovMap> inboundLocationPort(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return inboundMapper.inboundLocationPort(params);
	}

	@Override
	public Map<String, Object> reqSTO(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		String seq = inboundMapper.selectStockTransferSeq();
		String reqNo = "SMO" + seq;

		// inboundMapper.reqSTO(params);
		formMap.put("reqNo", reqNo);
		formMap.put("userId", params.get("userId"));

		inboundMapper.CreateReqM(formMap);

		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> map = (Map<String, Object>) checkList.get(i);

				Map<String, Object> setMap = new HashMap();
				setMap = (Map<String, Object>) map.get("item");
				setMap.put("reqNo", reqNo);
				setMap.put("userId", params.get("userId"));
				inboundMapper.CreateReqD(setMap);
			}
		}
		String deliveryNo = inboundMapper.selectDeliverySeq();
		formMap.put("reqNo", reqNo);
		formMap.put("deliveryNo", deliveryNo);
		inboundMapper.CreateDeliveryM(formMap);

		// for (int i = 0; i < checkList.size(); i++) {
		// inboundMapper.CreateDeliveryD(formMap);
		// }
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> map = (Map<String, Object>) checkList.get(i);

				Map<String, Object> setMap = new HashMap();
				setMap = (Map<String, Object>) map.get("item");
				setMap.put("reqNo", reqNo);
				setMap.put("deliveryNo", deliveryNo);
				setMap.put("userId", params.get("userId"));
				inboundMapper.CreateDeliveryD(setMap);
			}
		}
		inboundMapper.updateReqStatus(reqNo);

		String[] delvcd = { deliveryNo };

		formMap.put("parray", delvcd);
		formMap.put("userId", params.get("userId"));
		// formMap.put("prgnm", params.get("prgnm"));
		formMap.put("refdocno", "");
		formMap.put("salesorder", "");

		inboundMapper.CreateIssue(formMap);

		Map<String, Object> reMap = new HashMap();
		reMap.put("reqNo", reqNo);
		reMap.put("deliveryNo", deliveryNo);

		return reMap;
	}
}
