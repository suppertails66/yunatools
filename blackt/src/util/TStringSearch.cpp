#include "util/TStringSearch.h"
#include "util/TStringConversion.h"
#include "exception/TGenericException.h"
#include <sstream>
#include <iostream>

namespace BlackT {


TStringSearchResultList TStringSearch
    ::search(TStream& ifs, std::string searchStr) {
  TStringSearchTokenList searchList
    = getSearchList(searchStr);
  
  TStringSearchResultList results;
  
  while (!ifs.eof()) {
    int pos = ifs.tell();
    
    if (check(ifs, searchList)) {
      TStringSearchResult result;
      result.offset = pos;
      results.push_back(result);
    }
    
    ifs.seek(pos + 1);
  }
  
  return results;
}

TStringSearchResult TStringSearch
    ::searchForUnique(TStream& ifs, std::string searchStr) {
  TStringSearchResultList results = search(ifs, searchStr);
  
  if (results.size() != 1) {
    throw TGenericException(T_SRCANDLINE,
                            "TStringSearch::searchForUnique()",
                            "Did unique search with non-unique result");
  }
  
  return results[0];
}

TStringSearchTokenList TStringSearch
    ::getSearchList(std::string searchStr) {
  std::istringstream iss;
  iss.str(searchStr);
  
  TStringSearchTokenList results;
  
  while (iss.good()) {
    std::string next;
    iss >> next;
    
    if (next.empty()) break;
    
    if (next.compare("*") == 0) {
      TStringSearchToken token;
      token.type = TStringSearchToken::type_star;
      results.push_back(token);
      
//      std::cerr << "*" << std::endl;
    }
    // literal
    else {
      TStringSearchToken token;
      token.type = TStringSearchToken::type_literal;
      next = std::string("0x") + next;
      token.value = TStringConversion::stringToInt(next);
      results.push_back(token);
      
//      std::cerr << std::hex << (int)token.value << std::endl;
    }
  }
  
  return results;
}

bool TStringSearch
    ::check(TStream& ifs, const TStringSearchTokenList& tokenList) {
  if (ifs.remaining() < tokenList.size()) return false;
  
  for (TStringSearchTokenList::const_iterator it = tokenList.cbegin();
       it != tokenList.cend();
       ++it) {
    switch (it->type) {
    case TStringSearchToken::type_literal:
      if ((TByte)ifs.get() != it->value) return false;
      break;
    case TStringSearchToken::type_star:
      ifs.get();
      break;
    default:
      throw TGenericException(T_SRCANDLINE,
                              "TStringSearch::check()",
                              "Unknown token type");
      break;
    }
  }
  
  return true;
}

TStringSearchResultList TStringSearch::searchFullStream(
    TStream& ifs, std::string searchStr) {
  ifs.seek(0);
  return search(ifs, searchStr);
}

TStringSearchResult TStringSearch::searchFullStreamForUnique(
    TStream& ifs, std::string searchStr) {
  ifs.seek(0);
  return searchForUnique(ifs, searchStr);
}


};
