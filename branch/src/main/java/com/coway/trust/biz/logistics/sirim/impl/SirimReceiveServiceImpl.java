/**
 *
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.sirim.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.sirim.SirimReceiveService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("SirimReceiveService")
public class SirimReceiveServiceImpl extends EgovAbstractServiceImpl implements SirimReceiveService {

	private static final Logger Logger = LoggerFactory.getLogger(SirimReceiveServiceImpl.class);

	@Resource(name = "SirimReceiveMapper")
	private SirimReceiveMapper SirimReceiveMapper;

	@Override
	public List<EgovMap> receiveWarehouseList(Map<String, Object> params) {
		return SirimReceiveMapper.receiveWarehouseList(params);
	}

	@Override
	public List<EgovMap> selectReceiveList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimReceiveMapper.selectReceiveList(params);
	}

	@Override
	public List<EgovMap> detailReceiveList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimReceiveMapper.detailReceiveList(params);
	}

	@Override
	public List<EgovMap> getSirimReceiveInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimReceiveMapper.getSirimReceiveInfo(params);
	}


	@Override
	public void InsertReceiveInfo(Map<String, Object> InsertReceiveMap, List<EgovMap> ItemsAddList, int loginId) {

		int receiveStatus = Integer.parseInt((String) InsertReceiveMap.get("receiveStatus"));
		int transitId = Integer.parseInt((String) InsertReceiveMap.get("TransitId"));

		String getdocNo = SirimReceiveMapper.docNoCreateSeq();
		String SirimLoc="";
		if(receiveStatus == 4){
			Logger.debug("SirimLocTo!!!!!!!!!!!");
			SirimLoc = (String) InsertReceiveMap.get("SirimLocTo");

		}else{
			Logger.debug("SirimLocFrom !!!!!!!!!!!");
			SirimLoc = (String) InsertReceiveMap.get("SirimLocFrom");
		}


		for (int i = 0; i < ItemsAddList.size(); i++) {

			Map<String, Object> ItemsListMap = ItemsAddList.get(i);
			ItemsListMap.put("upuser_id", loginId);
			ItemsListMap.put("receiveStatus", receiveStatus);


			SirimReceiveMapper.SrmResultStatusUpdate(ItemsListMap);

			Map<String, Object> sirimNegMap = new HashMap<String, Object>();
			//int CrdSirimId = SirimReceiveMapper.ReceiveCreateSeq();
			//sirimNegMap.put("CrdSirimId", CrdSirimId);
			sirimNegMap.put("saveSirimNo", ItemsListMap.get("srmNo"));
			sirimNegMap.put("addTypeSirim", ItemsListMap.get("srmTypeId"));
			sirimNegMap.put("addSirimLoc", InsertReceiveMap.get("receiveInfoCourier"));
			sirimNegMap.put("addSirimQty", -1);
			sirimNegMap.put("getdocNo", getdocNo);
			sirimNegMap.put("crtuser_id", loginId);
			SirimReceiveMapper.insertReceiveSirim(sirimNegMap);

			Map<String, Object> sirimPosMap = new HashMap<String, Object>();
			//CrdSirimId = SirimReceiveMapper.ReceiveCreateSeq();
			//sirimPosMap.put("CrdSirimId", CrdSirimId);
			sirimPosMap.put("saveSirimNo", ItemsListMap.get("srmNo"));
			sirimPosMap.put("addTypeSirim", ItemsListMap.get("srmTypeId"));
			sirimPosMap.put("addSirimLoc", SirimLoc);
			sirimPosMap.put("addSirimQty", 1);
			sirimPosMap.put("getdocNo", getdocNo);
			sirimPosMap.put("crtuser_id", loginId);
            SirimReceiveMapper.insertReceiveSirim(sirimPosMap);

		}

		int total = SirimReceiveMapper.selectTransReceive(InsertReceiveMap);

		if(total <= 0){
			Map<String, Object> statusUpdate = new HashMap<String, Object>();
			statusUpdate.put("transitId", transitId);
			statusUpdate.put("userId", loginId);
			SirimReceiveMapper.SrmTransStatusUpdate(statusUpdate);
		}

	}

}
