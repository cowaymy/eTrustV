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

import com.coway.trust.AppConstants;
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
	public List<EgovMap> selectDepartmentList(Map<String, Object> params) {
		return AssetMngMapper.selectDepartmentList(params);
	}

	@Override
	public void insertAssetMng(Map<String, Object> params, List<EgovMap> detailAddList, int loginId) {

		int inassetid = AssetMngMapper.AssetCreateSeq();
		int newAssetCardId = AssetMngMapper.AssetCardIdSeq();

		int mastercategory = Integer.parseInt((String) params.get("mastercategory"));	
		int mastertype = Integer.parseInt((String) params.get("mastertype"));
		int mastercolor = Integer.parseInt((String) params.get("mastercolor"));
		int masterbrand = Integer.parseInt((String) params.get("masterbrand"));
		//double masterpurchaseamount = Double.parseDouble((String) params.get("masterpurchaseamount"));
		int masterdealer = Integer.parseInt((String) params.get("masterdealer"));
				
		params.put("inassetid", inassetid);
		params.put("masterstatus", 1);
		params.put("masterbreanch", 42);
		params.put("curr_dept_id", 38);
		params.put("curr_user_id", 0);
		params.put("loginId", loginId);
		params.put("mastercategory", mastercategory);
		params.put("mastertype", mastertype);
		params.put("mastercolor", mastercolor);
		params.put("masterbrand", masterbrand);
//		params.put("masterpurchaseamount", masterpurchaseamount);
		params.put("masterdealer", masterdealer);
		
		AssetMngMapper.insertMasterAsset(params);

		Map<String, Object> cardmap = new HashMap<String, Object>();

		cardmap.put("newAssetCardId", newAssetCardId);
		cardmap.put("newAssetId", inassetid);
		cardmap.put("loginId", loginId);
		
		Logger.debug("loginId  ??     : {}", loginId);
		
		AssetMngMapper.insertCopyAssetCard(cardmap);

		int detailsize = detailAddList.size();
		Logger.debug("detailsize     : {}", detailsize);
		if (detailsize > 0) {

			for (int i = 0; i < detailAddList.size(); i++) {
				int detailassetid = AssetMngMapper.AssetdetailCreateSeq();
				Map<String, Object> map = detailAddList.get(i);
				map.put("detailassetid", detailassetid);
				map.put("detailstatus", 1);
				map.put("inassetid", inassetid);
				setUserId(map, loginId);
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
	public void addItemAssetMng(List<EgovMap> itemAddList, int loginId) {

		for (int i = 0; i < itemAddList.size(); i++) {
			int insdetailAssetDid = AssetMngMapper.AssetdetailCreateSeq();
			int insAseetItemDid = AssetMngMapper.AssetItemCreateSeq();

			Logger.debug("itemAddList   : {}", itemAddList.get(i));

			Map<String, Object> map = itemAddList.get(i);
			Map<String, Object> resultmap = new HashMap<String, Object>();

			setUserId(resultmap, loginId);

			resultmap.put("detailassetid", insdetailAssetDid);
			resultmap.put("insAseetItemDid", insAseetItemDid);
			resultmap.put("detailstatus", 1);
			resultmap.put("inassetid", map.get("assetid"));
			resultmap.put("typeid", map.get("typeid"));
			resultmap.put("brandid", map.get("brandid"));
			resultmap.put("name1", map.get("name1"));
			resultmap.put("assetDRem", map.get("assetDRem"));
			resultmap.put("additemname", map.get("name3"));
			resultmap.put("additemvalue", map.get("valu"));
			resultmap.put("additemremark", map.get("assetDItmRem"));

			AssetMngMapper.insertDetailAsset(resultmap);
			AssetMngMapper.addAssetItm(resultmap);

		}

	}

	@Override
	public void updateItemAssetMng(Map<String, Object> params, int loginId) {

		List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
		for (int i = 0; i < updateItemList.size(); i++) {
			// Logger.debug("%%%%%%%%updateItemList%%%%%%%: {}", updateItemList.get(i));
		}
		List<EgovMap> ItemAddList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
		for (int i = 0; i < ItemAddList.size(); i++) {
			// Logger.debug("@@@@@@@ItemAddList@@@@@: {}", ItemAddList.get(i));
		}

		if (updateItemList.size() > 0) {
			for (int i = 0; i < updateItemList.size(); i++) {
				Map<String, Object> updateMap = updateItemList.get(i);

				updateMap.put("upuser_id", loginId);

				AssetMngMapper.updateItm(updateMap);
				AssetMngMapper.updateAssetDetail(updateMap);
			}
		}

		if (ItemAddList.size() > 0) {
			for (int i = 0; i < ItemAddList.size(); i++) {
				Map<String, Object> insMap = ItemAddList.get(i);

				int ItemCreateSeq = AssetMngMapper.AssetItemCreateSeq();
				int detailassetid = AssetMngMapper.AssetdetailCreateSeq();

				insMap.put("insAseetItemDid", ItemCreateSeq);
				insMap.put("detailassetid", insMap.get("assetdid"));
				insMap.put("additemname", insMap.get("name3"));
				insMap.put("additemvalue", insMap.get("valu"));
				insMap.put("additemremark", insMap.get("assetDItmRem"));
				insMap.put("add_crtuser_id", loginId);
				insMap.put("add_upuser_id", loginId);
				insMap.put("detailassetid", detailassetid);
				insMap.put("detailstatus", 1);
				insMap.put("inassetid", insMap.get("assetid"));
				insMap.put("typeid", insMap.get("typeid"));
				insMap.put("brandid", insMap.get("brandid"));
				insMap.put("crtuser_id", loginId);
				insMap.put("upuser_id", loginId);
				insMap.put("name1", insMap.get("name1"));
				insMap.put("assetDRem", insMap.get("assetDRem"));

				AssetMngMapper.insertDetailAsset(insMap);
				AssetMngMapper.addAssetItm(insMap);

			}
		}

	}

	@Override
	public void RemoveItemAssetMng(Map<String, Object> params) {

		// Logger.info("multyassetid @@@@@@: {}", params.get("multyassetid"));
		// Logger.info("itemassetdid $$$$$$$$$$: {}", params.get("itemassetdid"));

		AssetMngMapper.RemoveAssetDetail(params);
		AssetMngMapper.RemoveAssetItem(params);

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

				newAssetId = AssetMngMapper.AssetCreateSeq();
				newAssetCardId = AssetMngMapper.AssetCardIdSeq();

				Map<String, Object> params = new HashMap<String, Object>();
				params.put("assetid", assetid);
				params.put("loginId", loginId);
				params.put("newAssetId", newAssetId);
				params.put("newAssetCardId", newAssetCardId);

				AssetMngMapper.insertCopyAssetM(params);
				AssetMngMapper.insertCopyAssetCard(params);

				for (int j = 0; j < assetDList.size(); j++) {

					newAssetDId = AssetMngMapper.AssetdetailCreateSeq();

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

						newAssetDItmId = AssetMngMapper.AssetItemCreateSeq();
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

	private void setUserId(Map<String, Object> params, int loginId) {
		params.put("crtuser_id", loginId);
		params.put("upuser_id", loginId);
	}

	@Override
	public List<EgovMap> assetCardList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return AssetMngMapper.assetCardList(params);
	}

	@Override
	public void saveAssetCard(Map<String, Object> params) {
		AssetMngMapper.insertAssetCardFrom(params);
		AssetMngMapper.insertAssetCardTo(params);
		AssetMngMapper.updateAssetCard(params);

	}

	@Override
	public void updateAssetStatus(Map<String, Object> params) {
		AssetMngMapper.insertAssetCardFrom(params);
		AssetMngMapper.updateAssetCard(params);
		// TODO Auto-generated method stub

	}

}
