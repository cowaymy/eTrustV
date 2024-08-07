package com.coway.trust.api.sample;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(description = "샘플결과")
public class SampleDto
{
    @ApiModelProperty(value = "아이디")
    private String id;

    @ApiModelProperty(value = "이름")
    private String name;

    @ApiModelProperty(value = "설명")
    private String description;

    public String getId()
    {
        return id;
    }

    public void setId( String id )
    {
        this.id = id;
    }

    public String getName()
    {
        return name;
    }

    public void setName( String name )
    {
        this.name = name;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription( String description )
    {
        this.description = description;
    }

    public static SampleDto create( EgovMap egvoMap )
    {
    	return BeanConverter.toBean(egvoMap, SampleDto.class);
    	
//        SampleDto dto = new SampleDto();
//        dto.id = egvoMap.get( "id" ).toString();
//        dto.name = egvoMap.get( "name" ).toString();
//        dto.description = egvoMap.get( "description" ).toString();
//        return dto;
    }
}
