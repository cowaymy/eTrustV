package com.coway.trust.biz.logistics.memorandum;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MemorandumService {
	List<EgovMap> selectMemoRandumList(Map<String, Object> params);

	List<EgovMap> selectDeptSearchList();

	List<EgovMap> selectMemoType();

	Map<String, Object> memoSave(Map<String, Object> params);

	void memoDelete(Map<String, Object> params);

	int updatePassWord(Map<String, Object> params, Integer crtUserId);

	void memoHistSave (Map<String, Object> params) throws Exception;
}
