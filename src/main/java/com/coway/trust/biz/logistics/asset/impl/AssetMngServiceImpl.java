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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.asset.AssetMngService;
import com.coway.trust.web.logistics.LogisticsConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("AssetMngService")
public class AssetMngServiceImpl extends EgovAbstractServiceImpl implements AssetMngService {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "AssetMngMapper")
	private AssetMngMapper AssetMngMapper;

	@Override
	public List<EgovMap> selectAssetList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return AssetMngMapper.selectAssetList(params);
	}
	
	@Override
	public List<EgovMap> selectDetailList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return AssetMngMapper.selectDetailList(params);
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
	public List<EgovMap> selectTypeList(Map<String, Object> params) {
		return AssetMngMapper.selectTypeList(params);
	}
	
	@Override
	public void insertAssetMng(Map<String, Object> params, List<EgovMap> detailAddList) {
		
		int inassetid = AssetMngMapper.AssetCreateSeq();
		
		params.put("inassetid", inassetid);
		
		/*String chkId = LogisticsConstants.COURIER_CODE;
		List<EgovMap> list = courierMapper.selectCourierId(chkId);
		// params.put("curid", curid);
		String docNoID = String.valueOf(list.get(0).get("docNoId"));
		String docNo = String.valueOf(list.get(0).get("c1"));
		String docNoPrefix = String.valueOf(list.get(0).get("c2"));
		
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
		
		Map<String, Object> detailmap = new HashMap();
	
		int detailsize=detailAddList.size();
		logger.debug("detailsize     : {}", detailsize);	
		System.out.println("detailsize$$$  :  "+detailsize);
		if(detailsize > 0){
			System.out.println("통과!!!!!");
			for (int i = 0; i < detailAddList.size(); i++) {
				EgovMap map = (EgovMap) detailAddList.get(i);
			/*	detailmap.put("insdetailtype", map.get("insdetailtype"));
				detailmap.put("insdetailBrand", map.get("insdetailBrand"));
				detailmap.put("insdetailmodel", map.get("insdetailmodel"));
				detailmap.put("insdetailremark", map.get("insdetailremark"));*/
			
		/*		logger.debug("insdetailtype     : {}", map.get("insdetailtype"));	
				logger.debug("insdetailBrand     : {}", map.get("insdetailBrand"));	 
				logger.debug("insdetailmodel     : {}", map.get("insdetailmodel"));	 
				logger.debug("insdetailremark     : {}", map.get("insdetailremark"));	 */
				logger.debug("insdetailtype     : {}", map.get("codeName"));	
				logger.debug("insdetailBrand     : {}", map.get("name"));	 
				logger.debug("insdetailmodel     : {}", map.get("name1"));	 
				logger.debug("insdetailremark     : {}", map.get("assetDRem"));	
				
				
				AssetMngMapper.insertDetailAsset(map);
					
			}
			
		}
		 	//AssetMngMapper.insertAssetMng(params);
		
		
		
	}
	
	@Override
	public void motifyAssetMng(Map<String, Object> params) {
		AssetMngMapper.motifyAssetMng(params);

	}
	
	@Override
	public void deleteAssetMng(Map<String, Object> params) {
		// TODO Auto-generated method stub
		AssetMngMapper.deleteAssetMng(params);
	}
	
	
	
}