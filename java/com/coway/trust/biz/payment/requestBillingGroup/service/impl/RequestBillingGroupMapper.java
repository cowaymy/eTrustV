/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.payment.requestBillingGroup.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestBillingGroupMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 23.   KR-HAN        First creation
 * </pre>
 */
@Mapper("requestBillingGroupMapper")
public interface RequestBillingGroupMapper {

	 /**
	 * selectRequestBillingGroupList
	 * @Author KR-HAN
	 * @Date 2019. 10. 23.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectRequestBillingGroupList(Map<String, Object> params);

	 /**
	 * updateRequestBillingGroupReject
	 * @Author KR-HAN
	 * @Date 2019. 10. 23.
	 * @param params
	 * @return
	 */
	int updateRequestBillingGroupReject(Map<String, Object> params);

	 /**
	 * updateRequestBillingGroupArrpove
	 * @Author KR-HAN
	 * @Date 2019. 10. 23.
	 * @param params
	 * @return
	 */
	int updateRequestBillingGroupArrpove(Map<String, Object> params);

}
