package com.coway.trust.biz.logistics.importbl.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.importbl.ImportService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("importService")
public class ImportServiceImple extends EgovAbstractServiceImpl implements ImportService { 
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "importMapper")
	private ImportMapper importMapper;
	
	@Override
	public List<EgovMap> importBLList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return importMapper.importBLList(params);
	}
	
	@Override
	public List<EgovMap> importLocationList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return importMapper.importLocationList(params);
	}
	
	@Override
	public Map<String, Object> reqSTO(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		/* 2017-11-30 김덕호 위원 채번 변경 요청 */
		// String seq = importMapper.selectStockTransferSeq();
		// String reqNo = "SMO" + seq;
		String reqNo = importMapper.selectStockTransferSeq();

		formMap.put("reqNo", reqNo);
		formMap.put("userId", params.get("userId"));

		importMapper.CreateReqM(formMap);

		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> map = (Map<String, Object>) checkList.get(i);

				Map<String, Object> setMap = new HashMap();
				setMap = (Map<String, Object>) map.get("item");
				setMap.put("reqNo", reqNo);
				setMap.put("userId", params.get("userId"));
				importMapper.CreateReqD(setMap);
			}
		}
		String deliveryNo = importMapper.selectDeliverySeq();
		formMap.put("reqNo", reqNo);
		formMap.put("deliveryNo", deliveryNo);
		importMapper.CreateDeliveryM(formMap);

		List<EgovMap> delList = importMapper.selectDeliveryList(formMap);
		logger.info("delList : {} ", delList.toString());
		if (delList.size() > 0) {
			for (int i = 0; i < delList.size(); i++) {

				Map<String, Object> setMap = delList.get(i);
				logger.info("setMap : {} ", setMap);
				setMap.put("deliveryNo", deliveryNo);
				setMap.put("userId", params.get("userId"));
				importMapper.CreateDeliveryD(setMap);
			}
		}
		importMapper.updateReqStatus(reqNo);

		String[] delvcd = { deliveryNo };

		formMap.put("parray", delvcd);
		formMap.put("userId", params.get("userId"));
		// formMap.put("prgnm", params.get("prgnm"));
		formMap.put("refdocno", "");
		formMap.put("salesorder", "");

		importMapper.CreateIssue(formMap);

		Map<String, Object> reMap = new HashMap();
		reMap.put("reqNo", reqNo);
		reMap.put("deliveryNo", deliveryNo);

		return reMap;
	}
	
	@Override
	public List<EgovMap> searchSMO(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return importMapper.searchSMO(params);
	}
}
