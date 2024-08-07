package com.coway.trust.biz.logistics.memorandumApi;

import java.util.List;

import com.coway.trust.api.mobile.logistics.memorandumApi.MemorandumApiFormDto;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MemorandumApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface MemorandumApiService {



    List<EgovMap> selectMemorandumList(MemorandumApiFormDto param);
}
