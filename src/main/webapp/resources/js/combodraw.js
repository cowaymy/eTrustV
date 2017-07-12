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



function doGetCombo(url, groupCd , selCode, obj , type, callbackFn){
	
	$.ajax({
        type : "GET",
        url : url,
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
