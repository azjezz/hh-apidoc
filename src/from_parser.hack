/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc\Documentables;

use type Facebook\DefinitionFinder\{BaseParser, ScannedClassish};
use type Facebook\HHAPIDoc\Documentable;

use namespace HH\Lib\Vec;

/** Create `Documentable`s for all the supported defintions available
 * in the `Facebook\DefinitionFinder\BaseParser`.
 */
function from_parser(BaseParser $parser): vec<Documentable> {
  $top_level = Vec\concat(
    $parser->getClasses(),
    $parser->getInterfaces(),
    $parser->getTraits(),
    $parser->getFunctions(),
    $parser->getTypes(),
    $parser->getNewtypes(),
  ) |> Vec\sort_by(
    $$,
    $def ==> $def->getName(),
  ) |> Vec\map(
    $$,
    $def ==> shape(
      'sources' => vec[$def->getFileName()],
      'definition' => $def,
      'parent' => null,
    ),
  );

  $methods = Vec\map(
    $top_level,
    $data ==>  {
      $class = $data['definition'];
      if (!$class instanceof ScannedClassish) {
        return vec[];
      }

      return $class->getMethods()
        |> Vec\sort_by($$, $m ==> $m->getName())
        |> Vec\map(
          $$,
          $method ==> shape(
            'sources' => vec[$method->getName()],
            'definition' => $method,
            'parent' => $class,
          ),
        );
    }
  ) |> Vec\flatten($$);
  return Vec\concat($top_level, $methods);
}
