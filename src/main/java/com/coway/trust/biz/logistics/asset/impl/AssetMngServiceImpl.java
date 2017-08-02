/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.asset.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.asset.AssetMngService;
import com.coway.trust.web.logistics.LogisticsConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("AssetMngService")
public class AssetMngServiceImpl extends EgovAbstractServiceImpl implements AssetMngService {
	

	@Resource(name = "AssetMngMapper")
	private AssetMngMapper AssetMngMapper;

	@Override
	public List<EgovMap> selectAssetList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return AssetMngMapper.selectAssetList(params);
	}
	
	@Override
	public List<EgovMap> selectDealerList(Map<String, Object> params) {
		return AssetMngMapper.selectDealerList(params);
	}
	@Override
	public List<EgovMap> selectBrandList(Map<String, Object> params) {
		return AssetMngMapper.selectBrandList(params);
	}
	
	@Override
	public List<EgovMap> selectColorList(Map<String, Object> params) {
		return AssetMngMapper.selectColorList(params);
	}
	
	@Override
	public void insertAssetMng(Map<String, Object> params) {
		
		int inassetid = AssetMngMapper.AssetCreateSeq();
		
		params.put("inassetid", inassetid);
		
		System.out.println("임플 통과!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
		/*String chkId = LogisticsConstants.COURIER_CODE;
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
		courierMapper.insertCourier(params);*/
		AssetMngMapper.insertAssetMng(params);
	}
	
	
	
	
	
	
}