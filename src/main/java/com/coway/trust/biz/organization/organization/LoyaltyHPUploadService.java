package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import com.coway.trust.web.organization.organization.LoyaltyHPUploadDataVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface LoyaltyHPUploadService {

	String  getLoyltyHpUploadMasterUploadId(Map<String, Object> params);

	int   insertSAL0300Master (Map<String, Object> params);
	int   insertSAL0301Details (Map<String, Object> params);

	int  addLoyaltyHpUpload(Map<String, Object> params );
	int  removeItem(Map<String, Object> params );


	int  confrimItem(Map<String, Object> params );
	int  deActiveteItem(Map<String, Object> params );



	List<EgovMap> selectLoyaltyActiveHPList(Map<String, Object> params);

	List<EgovMap> selectLoyaltyHPUploadList(Map<String, Object> params);
	String insertUploadData(List<LoyaltyHPUploadDataVO> vos ,String userId );


	Map<String, Object>  selectLoyaltyHPUploadDetailInfo(Map<String, Object> params );
	List<EgovMap>  selectLoyaltyHPUploadDetailList (Map<String, Object> params );

	List<EgovMap> selectLoyaltyHPUploadDetailListForMember(Map<String, Object> params);

	List<EgovMap> selectLoyaltyHPUploadMemberStatusList(Map<String, Object> params);





}
