/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.materialdata.impl;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.materialdata.MaterialService;
import com.coway.trust.biz.logistics.stocks.StockService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("mstdataservice")
public class MaterialServiceImpl extends EgovAbstractServiceImpl implements MaterialService {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "mstMapper")
	private MaterialMapper mstMapper;

	@Override
	public List<EgovMap> selectStockMstList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return mstMapper.selectStockMstList(params);
	}

	@Override
	public List<EgovMap> selectMaterialMstItemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<EgovMap> list = mstMapper.selectMaterialMstItemList(params);
		
		List<EgovMap> listResult = new ArrayList<EgovMap>();
		EgovMap map = mstMapper.selectNonItemType();
		
		/*for (int i = 0 ; i < list.size(); i++){
			String type = (String)list.get(i).get("itemType");
			list.get(i).putAll(map);
		}*/
		return list;
	}

	@Override
	public EgovMap selectMaterialMstItemTypeList() {
		// TODO Auto-generated method stub
		return mstMapper.selectNonItemType();
	}

	@Override
	public void updateMaterialItemType(List<Object> updateList) {
		// TODO Auto-generated method stub
		
		for (int i = 0 ; i < updateList.size() ; i++){
    		Map<String, Object> updateMap = (Map<String, Object>) updateList.get(i);
    		mstMapper.updateMaterialItemType(updateMap);
		}
	}
	
	@Override
	public void insertMaterialItemType(Map<String, Object> params) {
		// TODO Auto-generated method stub
		
		int itmidseq = mstMapper.materialItmIdSeq();
		int itemtypeseq = mstMapper.materialItemTypeSeq();
		
		params.put("itmidseq", itmidseq);
		params.put("itemtypeseq", itemtypeseq);
				
		mstMapper.insertMaterialItemType(params);
	}
	
	
	@Override
	public void deleteMaterialItemType(Map<String, Object> params) {
		// TODO Auto-generated method stub
				
		mstMapper.deleteMaterialItemType(params);
	}
	
	
		
}