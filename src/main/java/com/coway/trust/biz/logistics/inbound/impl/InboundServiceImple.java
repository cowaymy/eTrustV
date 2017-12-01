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
		/* 2017-11-30 김덕호 위원 채번 변경 요청 */
		// String seq = inboundMapper.selectStockTransferSeq();
		// String reqNo = "SMO" + seq;
		String reqNo = inboundMapper.selectStockTransferSeq();

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

		List<EgovMap> delList = inboundMapper.selectDeliveryList(formMap);
		logger.info("delList : {} ", delList.toString());
		if (delList.size() > 0) {
			for (int i = 0; i < delList.size(); i++) {

				Map<String, Object> setMap = delList.get(i);
				logger.info("setMap : {} ", setMap);
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

	@Override
	public List<EgovMap> searchSMO(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return inboundMapper.searchSMO(params);
	}

	@Override
	public void receipt(Map<String, Object> params) {
		List<Object> checklist = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

		String delyCd = "";
		if (checklist.size() > 0) {
			Map<String, Object> map = (Map<String, Object>) checklist.get(0);
			Map<String, Object> imap = new HashMap();
			imap = (Map<String, Object>) map.get("item");
			delyCd = (String) imap.get("delyno");
		}

		// String[] delvcd = delyCd.split("∈");
		String[] delvcd = new String[1];
		delvcd[0] = delyCd;
		formMap.put("parray", delvcd);
		formMap.put("userId", params.get("userId"));
		// formMap.put("prgnm", params.get("prgnm"));
		formMap.put("refdocno", "");
		formMap.put("salesorder", "");

		inboundMapper.CreateIssue(formMap);

		if (serialList.size() > 0) {

			for (int j = 0; j < serialList.size(); j++) {

				Map<String, Object> insSerial = null;

				insSerial = (Map<String, Object>) serialList.get(j);

				insSerial.put("delno", delyCd);
				insSerial.put("userId", params.get("userId"));
				inboundMapper.insertLocSerial(insSerial);
			}
		}
	}
}
