package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("customer360ScoreCardMapper")
public interface Customer360ScoreCardMapper {

  List<EgovMap> customer360ScoreCardList(Map<String, Object> params);

}
