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

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("AssetMngService")
public class AssetMngServiceImpl extends EgovAbstractServiceImpl implements AssetMngService {

	private static final Logger Logger = LoggerFactory.getLogger(AssetMngServiceImpl.class);

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
		params.put("masterstatus", 1);
		params.put("masterbreanch", 42);
		params.put("curr_dept_id", 38);
		params.put("curr_user_id", 0);

		AssetMngMapper.insertMasterAsset(params);

		int detailsize = detailAddList.size();
		Logger.debug("detailsize     : {}", detailsize);
		if (detailsize > 0) {

			for (int i = 0; i < detailAddList.size(); i++) {
				int detailassetid = AssetMngMapper.AssetdetailCreateSeq();
				Map<String, Object> map = (Map<String , Object>)detailAddList.get(i);
				map.put("detailassetid", detailassetid);
				map.put("detailstatus", 1);
				map.put("inassetid", inassetid);
				map.put("add_crtuser_id", 99999999);
				map.put("add_upuser_id", 99999999);
				map.put("typeid", Integer.parseInt((String) map.get("typeid")));//
				map.put("brandid", Integer.parseInt((String) map.get("brandid")));//
				Logger.debug("insdetailtype     : {}", map.get("typeid"));
				Logger.debug("insdetailBrand     : {}", map.get("brandid"));
				Logger.debug("insdetailmodel     : {}", map.get("name1"));
				Logger.debug("insdetailremark     : {}", map.get("assetDRem"));

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

	
	
	@Override
	public void updateItemAssetMng(Map<String, Object> params) {
		
		
		int inassetid = AssetMngMapper.AssetCreateSeq();
		int detailassetid = AssetMngMapper.AssetdetailCreateSeq();
		
		params.put("inassetid", inassetid);
		params.put("detailassetid", detailassetid);
		params.put("detailstatus", 1);

		AssetMngMapper.insertDetailAsset(params);
		
		Map<String, Object> map = new HashMap();	
		
		params.put("detailstatus", 1);
		
		
	
		AssetMngMapper.updateItemAssetMng(map);
		
	
		
	}
	
	@Override
	public int insertCopyAsset(int assetid, int copyquantity, int loginId) {
		int cnt = 0;
		// 새로운 id 채번용
		int newAssetId = 0;
		int newAssetDId = 0;
		int newAssetDItmId = 0;
		int newAssetCardId = 0;

		// 기존 id 조회용
		int assetDId = 0;
		int assetDItmId = 0;

		List<EgovMap> assetMList = selectAssetM(assetid);
		List<EgovMap> assetDList = selectAssetD(assetid);
		List<EgovMap> assetItemList = selectAssetDItem(assetid);

		Logger.info("assetMList : {}", assetMList.toString());
		Logger.info("assetDList : {}", assetDList.toString());
		Logger.info("assetItemList : {}", assetItemList.toString());
		Logger.info("assetMList si: {}", assetMList.size());
		Logger.info("assetDList : {}", assetDList.size());
		Logger.info("assetItemList : {}", assetItemList.size());

		if (copyquantity > 0) {
			for (int i = 0; i < copyquantity; i++) {

				newAssetId = AssetMngMapper.selectMaxAssestId();
				newAssetCardId = AssetMngMapper.selectMaxCardId();

				Map<String, Object> params = new HashMap<String, Object>();
				params.put("assetid", assetid);
				params.put("loginId", loginId);
				params.put("newAssetId", newAssetId);
				params.put("newAssetCardId", newAssetCardId);

				AssetMngMapper.insertCopyAssetM(params);
				AssetMngMapper.insertCopyAssetCard(params);

				for (int j = 0; j < assetDList.size(); j++) {

					newAssetDId = AssetMngMapper.selectMaxAssestDId();

					assetDId = Integer.parseInt(String.valueOf(assetDList.get(j).get("assetDId")));

					Logger.debug("assetDId : {}", assetDId);
					Map<String, Object> params2 = new HashMap<String, Object>();
					params2.put("assetid", assetid);
					params2.put("loginId", loginId);
					params2.put("assetDId", assetDId);
					params2.put("newAssetId", newAssetId);
					params2.put("newAssetDId", newAssetDId);

					AssetMngMapper.insertCopyAssetD(params2);

					for (int z = 0; z < assetItemList.size(); z++) {

						newAssetDItmId = AssetMngMapper.selectMaxAssetDItmId();
						assetDItmId = Integer.parseInt(String.valueOf(assetItemList.get(z).get("assetDItmId")));

						Map<String, Object> params3 = new HashMap<String, Object>();

						params3.put("loginId", loginId);
						params3.put("assetDId", assetDId);
						params3.put("assetDItmId", assetDItmId);
						params3.put("newAssetDId", newAssetDId);
						params3.put("newAssetDItmId", newAssetDItmId);

						AssetMngMapper.insertCopyAssetDItmId(params3);

						cnt++;
					}
				}
			}
		}
		return cnt;

	}

	private List<EgovMap> selectAssetM(int assetid) {
		// TODO Auto-generated method stub
		List<EgovMap> list = AssetMngMapper.selectAssetM(assetid);
		return list;
	}

	private List<EgovMap> selectAssetD(int assetid) {
		// TODO Auto-generated method stub
		List<EgovMap> list = AssetMngMapper.selectAssetD(assetid);
		return list;
	}

	private List<EgovMap> selectAssetDItem(int assetid) {
		// TODO Auto-generated method stub
		List<EgovMap> list = AssetMngMapper.selectAssetDItem(assetid);
		return list;
	}
	
}
