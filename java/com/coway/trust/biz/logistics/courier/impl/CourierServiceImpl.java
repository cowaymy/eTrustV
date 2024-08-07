package com.coway.trust.biz.logistics.courier.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.courier.CourierService;
import com.coway.trust.web.logistics.LogisticsConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("courierService")
public class CourierServiceImpl extends EgovAbstractServiceImpl implements CourierService {

	private static final Logger logger = LoggerFactory.getLogger(CourierServiceImpl.class);

	@Resource(name = "courierMapper")
	private CourierMapper courierMapper;

	@Override
	public List<EgovMap> selectCourierList(Map<String, Object> params) {
		return courierMapper.selectCourierList(params);
	}

	@Override
	public List<EgovMap> selectCourierDetail(Map<String, Object> params) {
		return courierMapper.selectCourierDetail(params);
	}

	@Override
	public void motifyCourier(Map<String, Object> params) {
		courierMapper.motifyCourier(params);

	}

	@Override
	public void insertCourier(Map<String, Object> params) {
		String chkId = LogisticsConstants.COURIER_CODE;
		List<EgovMap> list = courierMapper.selectCourierId(chkId);
		// params.put("curid", curid);
		String docNoID = String.valueOf(list.get(0).get("docNoId"));
		String docNo = String.valueOf(list.get(0).get("c1"));
		String docNoPrefix = String.valueOf(list.get(0).get("c2"));

		int docNoLength = docNo.length();
		int NextNo = Integer.parseInt(docNo) + 1;
		String nextDocNo = String.valueOf(NextNo);
		int nextDocNoLength = nextDocNo.length();
		String docNoFormat = docNo.substring(0, docNoLength - nextDocNoLength) + nextDocNo;
		logger.debug("docNoLength : {}", docNoLength);
		logger.debug("NextNo : {}", NextNo);
		logger.debug("nextDocNo : {}", nextDocNo);
		logger.debug("nextDocNoLength : {}", nextDocNoLength);
		logger.debug("docNoLength - nextDocNoLength : {}", docNoLength - nextDocNoLength);
		logger.debug("docNoFormat : {}", docNoFormat);

		Map upmap = new HashMap<String, String>();
		upmap.put("chkId", chkId);
		upmap.put("docNoFormat", docNoFormat);
		courierMapper.updateDocNo(upmap);
		String curcode = docNoPrefix + docNoFormat;
		// params.put("chkId", chkId);
		params.put("curcode", curcode);
		courierMapper.insertCourier(params);

	}

	@Override
	public List<EgovMap> selectCourierComboList(Map<String, Object> params) {
		return courierMapper.selectCourierComboList(params);

	}

}
