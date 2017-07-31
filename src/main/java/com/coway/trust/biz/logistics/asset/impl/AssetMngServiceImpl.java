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

import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.asset.AssetMngService;

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
}