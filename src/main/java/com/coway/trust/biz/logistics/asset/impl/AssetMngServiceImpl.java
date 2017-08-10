/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.asset.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.asset.AssetMngService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

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
	public void insertAssetMng(Map<String, Object> params,List<EgovMap> detailAddList) {
	
		int inassetid = AssetMngMapper.AssetCreateSeq();

		params.put("inassetid", inassetid);
		params.put("masterstatus", 1);
		params.put("masterbreanch", 42);
		params.put("curr_dept_id", 38);
		params.put("curr_user_id", 0);
	
		AssetMngMapper.insertAssetMng(params);
	
		int detailsize=detailAddList.size();
		logger.debug("detailsize     : {}", detailsize);	
		if(detailsize > 0){
			for (int i = 0; i < detailAddList.size(); i++) {
				int detailassetid = AssetMngMapper.AssetdetailCreateSeq();
				Map<String , Object> map = (Map<String , Object>)detailAddList.get(i);
				map.put("detailassetid", detailassetid);
				map.put("detailstatus", 1);
				map.put("inassetid", inassetid);
				map.put("add_crtuser_id", 99999999);
				map.put("add_upuser_id", 99999999);
				map.put("typeid", Integer.parseInt((String) map.get("typeid")));//
				map.put("brandid",Integer.parseInt((String) map.get("brandid")));//
				logger.debug("insdetailtype     : {}", map.get("typeid"));	
				logger.debug("insdetailBrand     : {}", map.get("brandid"));	 
				logger.debug("insdetailmodel     : {}", map.get("name1"));	 
				logger.debug("insdetailremark     : {}", map.get("assetDRem"));	
								
				AssetMngMapper.insertDetailAsset(map);
					
			}
			
		}
		
		
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