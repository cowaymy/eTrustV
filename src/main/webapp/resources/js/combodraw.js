// onload

var eTrusttext = function(){
    return {
        option: {
            choose: "Choose One",
            all: "ALL"
        },
        alert0: "Session was timed out."
    };
}();

function f_header(val){
    if (val == 'Stock'){

        $("#harry").text(1);
        $("#neo").text(2);
        $("#sales").text(2);
        $("#netoty").text(2);
        $("#install").text(2);
        $("#retal").text(2);
        $("#tot").text(2);
    }
};

function doGetComboData(url, pdata , selCode, obj , type, callbackFn){

    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : pdata,
        dataType : "json",
        //async : false,
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefComboCode(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

function doGetComboCodeId(url, pdata , selCode, obj , type, callbackFn){

    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : pdata,
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefCombo(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

function doGetComboDataStatus(url, pdata , selCode, obj , type, callbackFn){
    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : pdata,
        dataType : "json",
        //async : false,
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefComboStatus(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            //alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

function doGetComboDataAndMandatory(url, pdata , selCode, obj , type, callbackFn){
    Common.ajax("GET", url, pdata, function(data) {
        var rData = data;
        doDefComboCodeAndMandatory(rData, selCode, obj , type,  callbackFn);
    }, function(jqXHR, textStatus, errorThrown){
        Common.alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
    });
} ;

function doGetCombo(url, groupCd , selCode, obj , type, callbackFn){

    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : { groupCode : groupCd},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefCombo(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

function doGetComboAndMandatory(url, groupCd , selCode, obj , type, callbackFn){
    Common.ajax("GET", url, { groupCode : groupCd}, function(data) {
        var rData = data;
        doDefComboAndMandatory(rData, selCode, obj , type,  callbackFn);
    }, function(jqXHR, textStatus, errorThrown){
        Common.alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
    });
} ;

function doGetComboAndGroup(url, groupCd , selCode, obj , type, callbackFn){
    Common.ajax("GET", url, { groupCode : groupCd}, function(data) {
        var rData = data;
        doDefComboAndGroup(rData, selCode, obj , type,  callbackFn);
    }, function(jqXHR, textStatus, errorThrown){
        Common.alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
    });
} ;

function doGetComboAndGroup2(url, pdata , selCode, obj , type, callbackFn){
    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : pdata,
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefComboAndGroup(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

function doGetProductCombo(url, stkType , selCode, obj , type, callbackFn){

    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : {stkType : stkType},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefCombo(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

function doGetComboOrder(url, groupCd, orderVal, selCode, obj , type, callbackFn){

    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : { groupCode : groupCd, orderValue : orderVal},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefCombo(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

function doGetComboSepa(url, groupCd ,separator, selCode, obj , type, callbackFn){

    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : { groupCode : groupCd , separator : separator},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefCombo(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

function doDataCombo(data , type , obj){
    var targetObj = document.getElementById(obj);
    var custom = "";

    for(var i=targetObj.length-1; i>=0; i--) {
        targetObj.remove( i );
    }
}

function doDefCombo(data, selCode, obj , type, callbackFn){
    var targetObj = document.getElementById(obj);
    var custom = "";

    for(var i=targetObj.length-1; i>=0; i--) {
        targetObj.remove( i );
    }
    obj= '#'+obj;
    if (type&&type!="M") {
        custom = (type == "S") ? eTrusttext.option.choose : ((type == "A") ? eTrusttext.option.all : "");
        $("<option />", {value: "", text: custom}).appendTo(obj);
    }else{
        $(obj).attr("multiple","multiple");
    }

    $.each(data, function(index,value) {
        //CODEID , CODE , CODENAME ,,description
        if(selCode==data[index].codeId){
            $('<option />', {value : data[index].codeId, text:data[index].codeName}).appendTo(obj).attr("selected", "true");
        }else{
            $('<option />', {value : data[index].codeId, text:data[index].codeName}).appendTo(obj);
        }
    });


    if(callbackFn){
        var strCallback = callbackFn+"()";
        eval(strCallback);
    }
};

function doDefComboStatus(data, selCode, obj , type, callbackFn){
    var targetObj = document.getElementById(obj);
    var custom = "";

    for(var i=targetObj.length-1; i>=0; i--) {
        targetObj.remove( i );
    }
    obj= '#'+obj;
    if (type&&type!="M") {
        custom = (type == "S") ? eTrusttext.option.choose : ((type == "A") ? eTrusttext.option.all : "");
        $("<option />", {value: "", text: custom}).appendTo(obj);
    }else{
        $(obj).attr("multiple","multiple");
    }

    $.each(data, function(index,value) {
        //CODEID , CODE , CODENAME ,,description
        if(selCode==data[index].codeId){
            $('<option />', {value : data[index].stusCodeId, text:data[index].codeName}).appendTo(obj).attr("selected", "true");
        }else{
            $('<option />', {value : data[index].stusCodeId, text:data[index].codeName}).appendTo(obj);
        }
    });


    if(callbackFn){
        var strCallback = callbackFn+"()";
        eval(strCallback);
    }
};

function doDefComboBasic(obj, type) {
    var targetObj = document.getElementById(obj);
    var custom = "";

    for (var i = targetObj.length - 1; i >= 0; i--) {
        targetObj.remove(i);
    }
    obj = '#' + obj;
    if (type && type != "M") {
        if(type != "N"){
            custom = (type == "S") ? eTrusttext.option.choose : ((type == "A") ? eTrusttext.option.all : "");
            $("<option />", {value: "", text: custom}).appendTo(obj);
        }
    } else {
        $(obj).attr("multiple", "multiple");
    }
    return obj;
}

function doDefComboAndMandatory(data, selCode, obj , type, callbackFn){
    var targetObj = document.getElementById(obj);
    var custom = "";

    for(var i=targetObj.length-1; i>=0; i--) {
        targetObj.remove( i );
    }
    obj= '#'+obj;
    if (type&&type!="M") {

    }else{
        $(obj).attr("multiple","multiple");
    }

    $.each(data, function(index,value) {
        //CODEID , CODE , CODENAME ,,description
        if(selCode==data[index].codeId){
            $('<option />', {value : data[index].codeId, text:data[index].codeName}).appendTo(obj).attr("selected", "true");
        }else{
            $('<option />', {value : data[index].codeId, text:data[index].codeName}).appendTo(obj);
        }
    });


    if(callbackFn){
        var strCallback = callbackFn+"()";
        eval(strCallback);
    }
};

function doDefComboAndGroup(data, selCode, obj , type, callbackFn){
    obj = doDefComboBasic(obj, type);

    var preGroup = "";

    $.each(data, function(index, value) {

        if(FormUtil.isNotEmpty(preGroup) && preGroup != value.codeName){
            $('</optgroup>').appendTo(obj);
            $('<optgroup label="' + value.codeName + '">').appendTo(obj);
        }else if(preGroup == ""){
            $('<optgroup label="' + value.codeName + '">').appendTo(obj);
        }

        if(selCode==value.stkId){
            $('<option />', {value : value.stkId, text:value.c1}).appendTo(obj).attr("selected", "true");
        }else{
            $('<option />', {value : value.stkId, text:value.c1}).appendTo(obj);
        }

        preGroup = value.codeName;

    });

    $('</optgroup>').appendTo(obj);

    if(callbackFn){
        var strCallback = callbackFn+"()";
        eval(strCallback);
    }
};


function doDefComboCode(data, selCode, obj , type, callbackFn){
    var targetObj = document.getElementById(obj);
    var custom = "";

    for(var i=targetObj.length-1; i>=0; i--) {
        targetObj.remove( i );
    }
    obj= '#'+obj;
    if (type&&type!="M") {
        custom = (type == "S") ? eTrusttext.option.choose : ((type == "A") ? eTrusttext.option.all : "");
        $("<option />", {value: "", text: custom}).appendTo(obj);
    }else{
        $(obj).attr("multiple","multiple");
    }

    $.each(data, function(index,value) {
        //CODEID , CODE , CODENAME ,,description
        if(selCode==data[index].code){
            $('<option />', {value : data[index].code, text:data[index].codeName}).appendTo(obj).attr("selected", "true");
        }else{
            $('<option />', {value : data[index].code, text:data[index].codeName}).appendTo(obj);
        }
    });


    if(callbackFn){
        var strCallback = callbackFn+"()";
        eval(strCallback);
    }
};

function doDefComboCodeAndMandatory(data, selCode, obj , type, callbackFn){
    var targetObj = document.getElementById(obj);
    var custom = "";

    for(var i=targetObj.length-1; i>=0; i--) {
        targetObj.remove( i );
    }
    obj= '#'+obj;
    if (type&&type!="M") {

    }else{
        $(obj).attr("multiple","multiple");
    }

    $.each(data, function(index,value) {
        //CODEID , CODE , CODENAME ,,description
        if(selCode==data[index].code){
            $('<option />', {value : data[index].code, text:data[index].codeName}).appendTo(obj).attr("selected", "true");
        }else{
            $('<option />', {value : data[index].code, text:data[index].codeName}).appendTo(obj);
        }
    });


    if(callbackFn){
        var strCallback = callbackFn+"()";
        eval(strCallback);
    }
};

function doGetComboAddr(url, pdata ,  selCode, obj , type, callbackFn){

    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : pdata,
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefCombo(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

function doGetComboDescription(url, groupCd , selCode, obj , type, callbackFn){

    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : { groupCode : groupCd},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefComboDescription(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

function doDefComboDescription(data, selCode, obj , type, callbackFn){
    var targetObj = document.getElementById(obj);
    var custom = "";

    for(var i=targetObj.length-1; i>=0; i--) {
        targetObj.remove( i );
    }
    obj= '#'+obj;
    if (type&&type!="M") {
        custom = (type == "S") ? eTrusttext.option.choose : ((type == "A") ? eTrusttext.option.all : "");
        $("<option />", {value: "", text: custom}).appendTo(obj);
    }else{
        $(obj).attr("multiple","multiple");
    }

    $.each(data, function(index,value) {
        //CODEID , CODE , CODENAME ,,description
        if(selCode==data[index].code){
            $('<option />', {value : data[index].codeId, text:data[index].description}).appendTo(obj).attr("selected", "true");
        }else{
            $('<option />', {value : data[index].codeId, text:data[index].description}).appendTo(obj);
        }
    });


    if(callbackFn){
        var strCallback = callbackFn+"()";
        eval(strCallback);
    }
};

function getAddrRelay(obj , value , tag , selvalue){
    var robj= '#'+obj;
    $(robj).attr("disabled",false);
    if (obj == 'mstate' && value!='1'){
        console.log($(".msap").length)
        for (var i = 0 ; i < $(".msap").length ; i++){
            doGetComboAddr('/common/selectAddrSelCodeList.do', tag , value , '', $(".msap").eq(i).attr('id') , 'S', ''); //청구처 리스트 조회
        }
    }else{
        doGetComboAddr('/common/selectAddrSelCodeList.do', tag , value , selvalue,obj, 'S', ''); //청구처 리스트 조회
    }
}

function getCdForStockList(obj , value , tag , selvalue){
    var robj= '#'+obj;
    $(robj).attr("disabled",false);
    doGetComboForStock('/common/selectInStckSelCodeList.do', tag , value , selvalue,obj, 'S', '');

}


function doGetComboForStock(url, groupCd ,codevalue ,  selCode, obj , type, callbackFn){
    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : { groupCode : groupCd , codevalue : codevalue},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefCombo(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} 

function doSysdate(v , obj){
	$.ajax({
        type : "GET",
        url : getContextPath() + '/common/SysdateCall.do',
        data : { value : v},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
        	$("#"+obj).val(data.date);
        },
        error: function(jqXHR, textStatus, errorThrown){
        	
        },
        complete: function(){
        }
    });
}